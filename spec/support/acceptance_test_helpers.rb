# frozen_string_literal: true

# External Libraries
require "rspec/expectations/expectation_target"
require "active_support/core_ext/string/filters"
require "active_support/concern"

# This library
require "appraisal/utils"

module AcceptanceTestHelpers
  extend ActiveSupport::Concern
  include DependencyHelpers

  BUNDLER_ENVIRONMENT_VARIABLES = %w[
    RUBYOPT
    BUNDLE_PATH
    BUNDLE_BIN_PATH
    BUNDLE_GEMFILE
    BUNDLER_SETUP
    BUNDLE_APP_CONFIG
    BUNDLE_USER_CONFIG
    BUNDLE_USER_CACHE
    BUNDLE_USER_PLUGIN
  ].freeze

  included do
    metadata[:type] = :acceptance

    before :parallel => true do
      unless Appraisal::Utils.support_parallel_installation?
        skip "This Bundler version does not support --jobs flag."
      end
    end

    before :git_local => true do
      unless Appraisal::Utils.support_git_local_installation?
        skip "This Bundler version does not support sourcing gems from git repos on local filesystem."
      end
    end

    before :ore => true do
      skip "ore-light not installed" unless ore_available?
    end

    before do
      cleanup_artifacts
      save_environment_variables
      unset_bundler_environment_variables
      setup_isolated_bundler_environment
      build_default_dummy_gems
      ensure_bundler_is_available
      add_binstub_path
      build_default_gemfile
    end

    after do
      restore_environment_variables
    end
  end

  # A head version of MRI ruby will require the -dev appended to the ruby string in the gemfile.
  # Unfortunately, there is no ENV variable that has access to the "dev" concept directly.
  # Perhaps the best we can do is parse RUBY_DESCRIPTION?
  #   > RUBY_DESCRIPTION
  #   "ruby 3.5.0dev (2025-02-20T18:14:37Z ... etc)
  def ruby_dev_append
    RUBY_DESCRIPTION.include?("dev") ? "-dev" : ""
  end

  def save_environment_variables
    @original_environment_variables = {}

    # Save all bundler variables plus PATH and the isolation variables we set
    vars_to_save = BUNDLER_ENVIRONMENT_VARIABLES + %w[
      PATH
      BUNDLE_IGNORE_FUNDING_REQUESTS
      BUNDLE_DISABLE_SHARED_GEMS
      GEM_PATH
    ]

    vars_to_save.each do |key|
      @original_environment_variables[key] = ENV[key]
    end
  end

  def unset_bundler_environment_variables
    BUNDLER_ENVIRONMENT_VARIABLES.each do |key|
      ENV[key] = nil
    end
    # Remove vendor/bundle bin paths from PATH to prevent conflicts with test binstubs
    # Bundler 4.0+ adds vendor/bundle/ruby/VERSION/bin to PATH which would be found
    # before the test directory's bin/ when running acceptance tests
    clean_vendor_bundle_from_path
    # Ensure GEM_PATH includes the parent project's vendor bundle so that
    # `bundle install --local` can find gems like thor that appraisal2 depends on
    setup_gem_path_for_local_install
  end

  def setup_isolated_bundler_environment
    # Ensure the test directory exists
    FileUtils.mkdir_p(current_directory)

    # Create an isolated .bundle directory within the test directory
    # This prevents bundler from reading or writing to the parent project's .bundle/config
    test_bundle_config_dir = File.join(current_directory, ".bundle")
    FileUtils.mkdir_p(test_bundle_config_dir)

    # Point bundler to use the test directory's config
    ENV["BUNDLE_APP_CONFIG"] = test_bundle_config_dir

    # Explicitly set the gemfile to the test directory's Gemfile
    # This ensures bundler never looks at the parent project's Gemfile
    ENV["BUNDLE_GEMFILE"] = File.join(current_directory, "Gemfile")

    # Disable settings that could cause side effects
    ENV["BUNDLE_IGNORE_FUNDING_REQUESTS"] = "1"
    ENV["BUNDLE_DISABLE_SHARED_GEMS"] = "1"

    # Set a test-specific cache directory to avoid polluting the user's cache
    test_cache_dir = File.join(current_directory, ".bundle", "cache")
    FileUtils.mkdir_p(test_cache_dir)
    ENV["BUNDLE_USER_CACHE"] = test_cache_dir
  end

  def setup_gem_path_for_local_install
    vendor_gem_path = File.join(PROJECT_ROOT, "vendor", "bundle", "ruby", RUBY_VERSION.split(".")[0..1].join(".") + ".0")
    if File.directory?(vendor_gem_path)
      ENV["GEM_PATH"] = [vendor_gem_path, ENV["GEM_PATH"]].compact.join(File::PATH_SEPARATOR)
    end
  end

  def clean_vendor_bundle_from_path
    return unless ENV["PATH"]

    paths = ENV["PATH"].split(File::PATH_SEPARATOR)
    cleaned_paths = paths.reject { |p| p.include?("vendor/bundle") }
    ENV["PATH"] = cleaned_paths.join(File::PATH_SEPARATOR)
  end

  def add_binstub_path
    # Add the test directory's bin folder to PATH using absolute path
    test_bin_path = File.join(current_directory, "bin")
    ENV["PATH"] = "#{test_bin_path}:#{ENV["PATH"]}"
  end

  def ore_available?
    system("which ore > /dev/null 2>&1")
  end

  def restore_environment_variables
    @original_environment_variables.each_pair do |key, value|
      ENV[key] = value
    end
  end

  def build_appraisal_file(content)
    write_file "Appraisals", content.strip_heredoc
  end

  def build_gemfile(content)
    write_file "Gemfile", content.strip_heredoc
  end

  def add_gemspec_to_gemfile
    in_test_directory do
      File.open("Gemfile", "a") { |file| file.puts "gemspec" }
    end
  end

  def build_gemspec
    write_file "stage.gemspec", <<-GEMSPEC.strip_heredoc.rstrip
      Gem::Specification.new do |s|
        s.name = 'stage'
        s.version = '0.1'
        s.summary = 'Awesome Gem!'
        s.authors = "Appraisal"
      end
    GEMSPEC
  end

  def content_of(path)
    file(path).read.tap do |content|
      content.gsub!(/(\S+): /, ':\\1 => ')
    end.strip
  end

  def file(path)
    Pathname.new(current_directory) + path
  end

  def be_exists
    be_exist
  end

  private

  def current_directory
    File.expand_path("tmp/stage", PROJECT_ROOT)
  end

  def write_file(filename, content)
    in_test_directory { File.open(filename, "w") { |file| file.puts content } }
  end

  def cleanup_artifacts
    FileUtils.rm_rf current_directory
  end

  def build_default_dummy_gems
    FileUtils.mkdir_p(TMP_GEM_ROOT)

    build_gem "dummy", "1.0.0"
    build_gem "dummy", "1.1.0"
  end

  def ensure_bundler_is_available
    # Check if bundle is available - the run method will not raise on error
    # because we pass false, so we need to check the output
    output = run "bundle -v 2>&1", false

    # If bundle -v succeeded, output should contain version info
    return if output && output.include?("Bundler version")

    puts <<-WARNING.strip_heredoc.rstrip
      Reinstall Bundler to #{TMP_GEM_ROOT} as `BUNDLE_DISABLE_SHARED_GEMS`
      is enabled.
    WARNING
    version = Appraisal::Utils.bundler_version

    run "gem install bundler --version #{version} --install-dir '#{TMP_GEM_ROOT}'"
  end

  def build_default_gemfile
    # Copy appraisal2 to the test directory for full isolation
    copy_appraisal2_to_test_directory

    build_gemfile <<-GEMFILE.strip_heredoc.rstrip
      source 'https://gem.coop'

      gem 'appraisal2', :path => './appraisal2'
    GEMFILE

    run "bundle install --local"
    # Support for binstubs --all was added to bundler's 1-17-stable branch
    #   and released with bundler v1.17.0.pre.2 (2018-10-13)
    # See:
    #   - https://github.com/rubygems/bundler/pull/6450
    #   - https://github.com/rubygems/bundler/commit/9d59fa41ef43aaccc6cf867a69a49648510c4df7#diff-06572a96a58dc510037d5efa622f9bec8519bc1beab13c9f251e97e657a9d4edR10
    run "bundle binstubs --all"
  end

  def copy_appraisal2_to_test_directory
    appraisal2_dest = File.join(current_directory, "appraisal2")
    FileUtils.mkdir_p(appraisal2_dest)

    # Copy lib directory
    FileUtils.cp_r(File.join(PROJECT_ROOT, "lib"), appraisal2_dest)

    # Copy exe directory
    FileUtils.cp_r(File.join(PROJECT_ROOT, "exe"), appraisal2_dest)

    # Copy gemspec
    FileUtils.cp(File.join(PROJECT_ROOT, "appraisal2.gemspec"), appraisal2_dest)
  end

  # Path to the local appraisal2 copy in the test directory
  # Tests should use this instead of PROJECT_ROOT when referencing appraisal2 in Gemfiles
  def local_appraisal2_path
    "./appraisal2"
  end

  # Constant for use in heredocs - returns the path as a string suitable for Gemfile
  APPRAISAL2_GEM_PATH = "./appraisal2"

  def in_test_directory(&block)
    FileUtils.mkdir_p current_directory
    Dir.chdir current_directory, &block
  end

  def run(command, raise_on_error = true)
    in_test_directory do
      # GUARD: Fail fast if we're somehow in the project root directory
      # This should never happen - all test commands must run in tmp/stage
      if Dir.pwd == PROJECT_ROOT
        raise "ISOLATION ERROR: Command #{command.inspect} is running in PROJECT_ROOT instead of test directory. " \
          "This would pollute the project's Gemfile.lock!"
      end

      # Set BUNDLE_GEMFILE and BUNDLE_APP_CONFIG to point to this test directory
      # This prevents bundler from accidentally using the parent project's Gemfile or config
      # We set these in Ruby ENV so they're inherited by all subprocesses (including bundle exec)
      test_gemfile = File.join(current_directory, "Gemfile")
      test_bundle_config = File.join(current_directory, ".bundle")

      # Temporarily set the environment for this command
      original_bundle_gemfile = ENV["BUNDLE_GEMFILE"]
      original_bundle_app_config = ENV["BUNDLE_APP_CONFIG"]

      begin
        ENV["BUNDLE_GEMFILE"] = test_gemfile
        ENV["BUNDLE_APP_CONFIG"] = test_bundle_config

        # Debug output if VERBOSE
        if ENV["VERBOSE"]
          puts "DEBUG: Running command: #{command}"
          puts "DEBUG: Current directory: #{Dir.pwd}"
          puts "DEBUG: BUNDLE_GEMFILE: #{ENV["BUNDLE_GEMFILE"]}"
          puts "DEBUG: BUNDLE_APP_CONFIG: #{ENV["BUNDLE_APP_CONFIG"]}"
          puts "DEBUG: PATH first 3 entries: #{ENV["PATH"].split(":").first(3).inspect}"
          appraisal_bin = File.join(current_directory, "bin", "appraisal")
          puts "DEBUG: appraisal binstub exists? #{File.exist?(appraisal_bin)}"
        end

        # Capture both stdout and stderr
        output = %x(#{command} 2>&1)
        exitstatus = $?.exitstatus

        puts output if ENV["VERBOSE"]

        if raise_on_error && exitstatus != 0
          raise <<-ERROR_MESSAGE.strip_heredoc.rstrip
            Command #{command.inspect} exited with status #{exitstatus}. Output:
            #{output.gsub(/^/, "  ")}
          ERROR_MESSAGE
        end

        output
      ensure
        # Restore original values (which may be the test isolation values from setup)
        ENV["BUNDLE_GEMFILE"] = original_bundle_gemfile
        ENV["BUNDLE_APP_CONFIG"] = original_bundle_app_config
      end
    end
  end
end

RSpec.configure do |config|
  config.include AcceptanceTestHelpers, :type => :acceptance
end
