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

  describe "#skip_jruby_acceptance_example" do
    it "skips before fixture setup when the example opts out of JRuby" do
      stub_const("RUBY_ENGINE", "jruby")
      example = instance_double(RSpec::Core::Example, :metadata => {:skip_on_jruby => true})

      expect(self).to receive(:skip).with(/intentionally skipped on JRuby/)

      send(:skip_jruby_acceptance_example, example)
    end

    it "does not skip an example without the JRuby opt-out" do
      stub_const("RUBY_ENGINE", "jruby")
      example = instance_double(RSpec::Core::Example, :metadata => {})

      expect(self).not_to receive(:skip)

      send(:skip_jruby_acceptance_example, example)
    end
  end

  describe "#install_test_binstub_gem_path_prelude" do
    it "normalizes empty Bundler version variables in the bundle binstub" do
      FileUtils.mkdir_p(File.join(Dir.pwd, "tmp"))

      Dir.mktmpdir("binstub", File.join(Dir.pwd, "tmp")) do |dir|
        binstub = File.join(dir, "bundle")
        File.write(binstub, <<-RUBY.strip_heredoc)
          #!/usr/bin/env ruby
          require "rubygems"
          load Gem.bin_path("bundler", "bundle")
        RUBY

        install_test_binstub_gem_path_prelude(dir)

        contents = File.read(binstub)
        expect(contents).to include('ENV["BUNDLER_VERSION"] = nil')
        expect(contents).to include('ENV["BUNDLE_VERSION"] = nil')
        expect(contents).to include("APPRAISAL_TEST_EMPTY_BUNDLER_VERSION_NORMALIZED")
      end
    end

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

  describe "#command_with_test_bundler" do
    it "invokes the harness-selected Bundler instead of relying on the engine default" do
      stub_env("APPRAISAL_TEST_BUNDLER_VERSION" => "4.0.18")

      command = send(:command_with_test_bundler, "bundle install --local || bundle binstubs --all")
      command_with_environment = send(
        :command_with_test_bundler,
        "BUNDLE_LOCKFILE=gemfiles/bundler_locked.gemfile.lock bundle install --gemfile gemfiles/bundler_locked.gemfile"
      )

      expect(command).to include(RbConfig.ruby)
      expect(command).to include("Gem.bin_path")
      expect(command).to include("4.0.18")
      expect(command).not_to include("BUNDLER_VERSION=")
      expect(command).to include(" || ")
      expect(command).to include("install --local")
      expect(command).to include("binstubs --all")
      expect(command_with_environment).to start_with("BUNDLE_LOCKFILE=gemfiles/bundler_locked.gemfile.lock ")
      expect(command_with_environment).to include("#{RbConfig.ruby} -e")
      expect(command_with_environment).to include("install --gemfile gemfiles/bundler_locked.gemfile")
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

  describe "#setup_gem_path_for_local_install" do
    it "keeps the repository for the Bundler running the test process" do
      original_gem_path = ENV["GEM_PATH"]
      begin
        active_bundler = instance_double(Gem::Specification, :base_dir => "/active/bundler")
        allow(Gem.loaded_specs).to receive(:[]).with("bundler").and_return(active_bundler)
        allow(Gem).to receive_messages(:dir => "/system/gems", :path => [])

        send(:setup_gem_path_for_local_install)

        expect(ENV.fetch("GEM_PATH").split(File::PATH_SEPARATOR)).to include("/active/bundler")
      ensure
        ENV["GEM_PATH"] = original_gem_path
      end
    end
  end

  describe "#setup_isolated_bundler_environment" do
    it "routes gem.coop fixture sources through RubyGems.org" do
      original_mirror = ENV[AcceptanceTestHelpers::GEM_COOP_MIRROR_ENV]

      Dir.mktmpdir("isolated-bundler") do |directory|
        begin
          allow(self).to receive(:current_directory).and_return(directory)

          send(:setup_isolated_bundler_environment)

          expect(ENV[AcceptanceTestHelpers::GEM_COOP_MIRROR_ENV]).to eq("https://rubygems.org")
        ensure
          ENV[AcceptanceTestHelpers::GEM_COOP_MIRROR_ENV] = original_mirror
        end
      end
    end
  end

  describe "#build_default_gemfile" do
    it "does not import a Bundler version from the outer test bundle" do
      Dir.mktmpdir("default-stage") do |directory|
        allow(self).to receive(:current_directory).and_return(directory)
        allow(self).to receive(:copy_appraisal2_to_test_directory)
        allow(self).to receive(:run)
        allow(self).to receive(:install_test_binstub_gem_path_prelude)

        send(:build_default_gemfile)

        contents = File.read(File.join(directory, "Gemfile"))
        expect(contents).to include("source 'https://rubygems.org'")
        expect(contents).to include("gem 'appraisal2', :path => './appraisal2'")
        expect(contents).not_to include("gem 'bundler'")
      end
    end
  end
end
