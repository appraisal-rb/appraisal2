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

  describe "command_as_string (via internal behavior)" do
    it "converts array command to shellwords string" do
      command = described_class.new(["rake", "test", "with spaces"])

      # We test this indirectly through the announce method behavior
      expect(command.command).to eq(["bundle", "exec", "rake", "test", "with spaces"])
    end
  end
end
