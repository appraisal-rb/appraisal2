# frozen_string_literal: true

RSpec.describe AcceptanceTestHelpers do
  include described_class

  describe "#restore_environment_variables" do
    it "restores GEM_HOME after fixture gem setup changes it" do
      stub_env("GEM_HOME" => "/original/gem/home")

      save_environment_variables
      ENV["GEM_HOME"] = TMP_GEM_ROOT
      restore_environment_variables

      expect(ENV["GEM_HOME"]).to eq("/original/gem/home")
    end
  end

  describe "#test_bundler_version" do
    it "uses the Ruby-shipped Bundler on TruffleRuby instead of the newest installed spec" do
      stub_const("RUBY_ENGINE", "truffleruby")
      allow(self).to receive(:ruby_shipped_bundler_version).and_return("2.2.32")

      newer_spec = instance_double(Gem::Specification, :version => Gem::Version.new("2.5.23"))
      allow(Gem::Specification).to receive(:find_all_by_name).with("bundler").and_return([newer_spec])

      expect(test_bundler_version).to eq("2.2.32")
    end

    it "falls back to the newest installed Bundler spec on TruffleRuby when the shipped version cannot be detected" do
      stub_const("RUBY_ENGINE", "truffleruby")
      allow(self).to receive(:ruby_shipped_bundler_version).and_return(nil)

      newer_spec = instance_double(Gem::Specification, :version => Gem::Version.new("2.5.23"))
      allow(Gem::Specification).to receive(:find_all_by_name).with("bundler").and_return([newer_spec])

      expect(test_bundler_version).to eq("2.5.23")
    end

    it "uses the newest installed Bundler spec on other engines" do
      stub_const("RUBY_ENGINE", "ruby")

      older_spec = instance_double(Gem::Specification, :version => Gem::Version.new("2.4.0"))
      newer_spec = instance_double(Gem::Specification, :version => Gem::Version.new("2.5.0"))
      allow(Gem::Specification).to receive(:find_all_by_name).with("bundler").and_return([older_spec, newer_spec])

      expect(test_bundler_version).to eq("2.5.0")
    end
  end
end
