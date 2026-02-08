# frozen_string_literal: true

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

    before do
      allow(Kernel).to receive(:system).and_return(true)
      allow(Bundler).to receive(:with_original_env).and_yield
      allow(Appraisal::Utils).to receive(:bundler_version).and_return("2.0.0")
      # Mock system call for ensure_bundler_is_available (which uses system)
      allow_any_instance_of(described_class).to receive(:system).and_return(true)
      allow_any_instance_of(described_class).to receive(:puts)
    end

    context "by default" do
      it "wraps execution in Bundler.with_original_env and ensures bundler is available" do
        command = described_class.new(command_string, :gemfile => gemfile)

        expect(Bundler).to receive(:with_original_env).and_yield
        expect_any_instance_of(described_class).to receive(:ensure_bundler_is_available)

        command.run
      end
    end

    context "when skip_bundle_exec is true" do
      it "does not wrap execution in Bundler.with_original_env and does not ensure bundler" do
        command = described_class.new(command_string, :gemfile => gemfile, :skip_bundle_exec => true)

        expect(Bundler).not_to receive(:with_original_env)
        expect_any_instance_of(described_class).not_to receive(:ensure_bundler_is_available)

        command.run
      end
    end
  end
end
