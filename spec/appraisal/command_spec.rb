# frozen_string_literal: true

require "tmpdir"

require "appraisal/command"

RSpec.describe Appraisal::Command do
  describe "#initialize" do
    it "stores the gemfile path" do
      command = described_class.new(["rake", "test"], :gemfile => "/path/to/Gemfile")
      expect(command.gemfile).to eq("/path/to/Gemfile")
    end

    it "stores custom environment variables" do
      command = described_class.new(["rake", "test"], :env => {"RAILS_ENV" => "test"})
      expect(command.env).to eq({"RAILS_ENV" => "test"})
    end

    it "defaults to empty env hash" do
      command = described_class.new(["rake", "test"])
      expect(command.env).to eq({})
    end

    context "when command starts with bundle" do
      it "keeps the command as-is for string" do
        command = described_class.new("bundle exec rake test")
        expect(command.command).to eq("bundle exec rake test")
      end

      it "keeps the command as-is for array" do
        command = described_class.new(["bundle", "exec", "rake", "test"])
        expect(command.command).to eq(["bundle", "exec", "rake", "test"])
      end
    end

    context "when command does not start with bundle" do
      it "prepends bundle exec for array command" do
        command = described_class.new(["rake", "test"])
        expect(command.command).to eq(["bundle", "exec", "rake", "test"])
      end

      it "prepends bundle exec for string-like commands" do
        command = described_class.new(["rspec", "spec/"])
        expect(command.command).to eq(["bundle", "exec", "rspec", "spec/"])
      end
    end
  end

  describe "#run" do
    let(:command_string) { "rake test" }
    let(:gemfile) { "/path/to/Gemfile" }
    let(:run_env) { {"APPRAISAL_INITIALIZED" => "1", "BUNDLE_GEMFILE" => gemfile} }

    let(:command) { described_class.new(command_string, :gemfile => gemfile) }

    before do
      allow(Kernel).to receive(:system).and_return(true)
      allow(Appraisal::Utils).to receive(:bundler_version).and_return("2.0.0")
      # Mock system call for ensure_bundler_is_available (which uses system)
      allow(command).to receive(:system).and_return(true)
      allow(command).to receive(:puts)
    end

    context "with default settings" do
      it "builds an isolated Bundler environment and ensures bundler is available" do
        allow(command).to receive(:bundler_env).and_return({})
        allow(command).to receive(:ensure_bundler_is_available)
        allow(command).to receive(:ensure_locked_bundler_is_available)

        command.run

        expect(command).to have_received(:bundler_env).with(hash_including("GEM_PATH" => ENV["APPRAISAL_TEST_SYSTEM_GEM_PATH"].to_s))
        expect(command).to have_received(:ensure_bundler_is_available).with({})
        expect(command).to have_received(:ensure_locked_bundler_is_available).with({})
      end
    end

    context "with BUNDLE_PATH set in environment" do
      it "preserves BUNDLE_PATH and strips bundler activation markers" do
        # This example exercises the real environment builder used by Command#run.
        # rubocop:disable Env/Assign
        original_bundle_path = ENV["BUNDLE_PATH"]
        original_rubyopt = ENV["RUBYOPT"]
        original_bundler_setup = ENV["BUNDLER_SETUP"]
        original_bundler_version = ENV["BUNDLER_VERSION"]
        begin
          ENV["BUNDLE_PATH"] = "/custom/path"
          ENV["RUBYOPT"] = "-rbundler/setup -W0"
          ENV["BUNDLER_SETUP"] = "1"
          ENV["BUNDLER_VERSION"] = "4.0.3"

          allow(Bundler).to receive(:unbundled_env).and_return({})

          expect(Kernel).to receive(:system) do |env, _command|
            expect(env["BUNDLE_PATH"]).to eq("/custom/path")
            expect(env["BUNDLER_SETUP"]).to be_nil
            expect(env["BUNDLE_VERSION"]).to be_nil
            expect(env["BUNDLER_VERSION"]).to be_nil
            expect(env["RUBYOPT"]).to eq("-W0")
            true
          end

          command.run
        ensure
          ENV["BUNDLE_PATH"] = original_bundle_path
          ENV["RUBYOPT"] = original_rubyopt
          ENV["BUNDLER_SETUP"] = original_bundler_setup
          ENV["BUNDLER_VERSION"] = original_bundler_version
        end
        # rubocop:enable Env/Assign
      end
    end

    context "when Bundler environment helpers are available" do
      it "uses unbundled_env instead of original_env as the subprocess base" do
        allow(Bundler).to receive_messages(
          :unbundled_env => {"PATH" => "/original/bin"},
          :original_env => {"BUNDLE_FOO" => "leaked", "PATH" => "/original/bin"}
        )

        expect(Kernel).to receive(:system) do |env, _command|
          expect(env["BUNDLE_FOO"]).to be_nil
          true
        end

        command.run

        expect(Bundler).to have_received(:unbundled_env)
        expect(Bundler).not_to have_received(:original_env)
      end
    end

    context "with an acceptance test Bundler version" do
      it "pins the subprocess to the harness-selected Bundler version" do
        harness_command = described_class.new(command_string, :gemfile => gemfile, :env => {"APPRAISAL_TEST_BUNDLER_VERSION" => "4.0.16"})
        allow(harness_command).to receive(:system).and_return(true)
        allow(harness_command).to receive(:puts)
        allow(Bundler).to receive(:unbundled_env).and_return({})

        expect(Kernel).to receive(:system) do |env, _command|
          expect(env["BUNDLE_VERSION"]).to eq("4.0.16")
          expect(env["BUNDLER_VERSION"]).to eq("4.0.16")
          true
        end

        harness_command.run
      end
    end

    context "with a locked appraisal Bundler version" do
      it "installs and selects the Bundler version from the appraisal lockfile" do
        Dir.mktmpdir("appraisal-command-lock") do |dir|
          gemfile = File.join(dir, "locked.gemfile")
          File.write(gemfile, %(source "https://gem.coop"\n))
          File.write("#{gemfile}.lock", [
            "GEM",
            "  remote: https://gem.coop/",
            "  specs:",
            "",
            "PLATFORMS",
            "  ruby",
            "",
            "DEPENDENCIES",
            "",
            "BUNDLED WITH",
            "   4.0.5",
            ""
          ].join("\n"))
          gem_home = File.join(dir, "gems")

          locked_command = described_class.new(command_string, :gemfile => gemfile, :env => {"GEM_HOME" => gem_home, "GEM_PATH" => ""})
          allow(locked_command).to receive(:system).and_return(true)
          allow(locked_command).to receive(:puts)
          allow(Bundler).to receive(:unbundled_env).and_return({})

          allow(locked_command).to receive(:system)
            .with(hash_including("GEM_HOME" => gem_home), a_string_matching(/ruby --disable=gems .*bundler/m))
            .and_return(true)
          expect(Kernel).to receive(:system) do |env, _command|
            expect(env["BUNDLE_GEMFILE"]).to eq(gemfile)
            expect(env["BUNDLE_VERSION"]).to eq("4.0.5")
            expect(env["BUNDLER_VERSION"]).to eq("4.0.5")
            expect(env["BUNDLE_BIN_PATH"]).to be_nil
            true
          end

          locked_command.run

          expect(locked_command).to have_received(:system)
            .with(hash_including("GEM_HOME" => gem_home), a_string_matching(/ruby --disable=gems .*bundler/m))
            .twice
        end
      end
    end
  end
end
