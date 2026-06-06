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
      it "wraps execution in with_bundler_env and ensures bundler is available" do
        allow(command).to receive(:with_bundler_env).and_yield
        allow(command).to receive(:ensure_bundler_is_available)

        command.run

        expect(command).to have_received(:with_bundler_env)
        expect(command).to have_received(:ensure_bundler_is_available)
      end
    end

    context "with BUNDLE_PATH set in environment" do
      it "preserves BUNDLE_PATH and strips bundler activation markers" do
        # This example exercises real ENV mutation inside Command#with_bundler_env.
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

          allow(Bundler).to receive(:original_env).and_return({})

          expect(Kernel).to receive(:system) do
            expect(ENV["BUNDLE_PATH"]).to eq("/custom/path")
            expect(ENV["BUNDLER_SETUP"]).to be_nil
            expect(ENV["BUNDLER_VERSION"]).to be_nil
            expect(ENV["RUBYOPT"]).to eq("-W0")
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
          allow(Bundler).to receive(:original_env).and_return({})

          allow(locked_command).to receive(:system).with(%(gem list --silent -i bundler)) do
            expect(ENV["GEM_HOME"]).to eq(gem_home)
            true
          end
          allow(locked_command).to receive(:system).with(%(gem list --silent -i bundler -v "4.0.5")) do
            expect(ENV["GEM_HOME"]).to eq(gem_home)
            true
          end
          expect(Kernel).to receive(:system) do
            expect(ENV["BUNDLE_GEMFILE"]).to eq(gemfile)
            expect(ENV["BUNDLER_VERSION"]).to eq("4.0.5")
            expect(ENV["BUNDLE_BIN_PATH"]).to be_nil
            true
          end

          locked_command.run

          expect(locked_command).to have_received(:system).with(%(gem list --silent -i bundler))
          expect(locked_command).to have_received(:system).with(%(gem list --silent -i bundler -v "4.0.5"))
        end
      end
    end
  end
end
