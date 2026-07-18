# frozen_string_literal: true

require "tmpdir"

RSpec.describe AcceptanceTestHelpers, :appraisal_fixture => false, :dummy_gems => false do
  include described_class

  describe "#setup_acceptance_fixture" do
    it "does not prepare dummy gems or bundle fixtures without opt-in metadata" do
      allow(self).to receive(:build_default_dummy_gems)
      allow(self).to receive(:copy_default_stage_template)
      allow(self).to receive(:add_binstub_path)

      send(:setup_acceptance_fixture, {})

      expect(self).not_to have_received(:build_default_dummy_gems)
      expect(self).not_to have_received(:copy_default_stage_template)
      expect(self).not_to have_received(:add_binstub_path)
    end

    it "prepares the cached bundle fixture and dummy gems when metadata opts in" do
      allow(self).to receive(:build_default_dummy_gems)
      allow(self).to receive(:copy_default_stage_template)
      allow(self).to receive(:add_binstub_path)

      send(:setup_acceptance_fixture, {:appraisal_fixture => true, :dummy_gems => true})

      expect(self).to have_received(:build_default_dummy_gems)
      expect(self).to have_received(:copy_default_stage_template)
      expect(self).to have_received(:add_binstub_path)
    end
  end

  describe "#install_test_binstub_gem_path_prelude" do
    it "pins generated test binstubs to the harness-selected Bundler version" do
      FileUtils.mkdir_p(File.join(Dir.pwd, "tmp"))

      Dir.mktmpdir("binstub", File.join(Dir.pwd, "tmp")) do |dir|
        binstub = File.join(dir, "appraisal")
        File.write(binstub, <<-RUBY.strip_heredoc)
          #!/usr/bin/env ruby
          require "pathname"
          bundle_binstub = File.expand_path("../bundle", __FILE__)
          load(bundle_binstub)
          require "rubygems"
          require "bundler/setup"
          load Gem.bin_path("appraisal2", "appraisal")
        RUBY

        install_test_binstub_gem_path_prelude(dir)

        contents = File.read(binstub)
        bundler_pin_index = contents.index('ENV["BUNDLER_VERSION"] = ENV["APPRAISAL_TEST_BUNDLER_VERSION"]')
        bundle_binstub_load_index = contents.index("load(bundle_binstub)")

        expect(contents).to include('ENV["BUNDLE_VERSION"] = ENV["APPRAISAL_TEST_BUNDLER_VERSION"]')
        expect(bundler_pin_index).to be < bundle_binstub_load_index
      end
    end
  end

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
