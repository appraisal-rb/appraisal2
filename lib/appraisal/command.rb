# frozen_string_literal: true

require "shellwords"

module Appraisal
  # Executes commands with a clean environment
  class Command
    attr_reader :command, :env, :gemfile

    # BUNDLE_* environment variables that must be preserved for proper bundler operation
    # and test isolation. These are preserved after starting from Bundler's
    # unbundled environment so Appraisal can run a fresh Bundler subprocess
    # without losing the target appraisal and isolation settings:
    # - Bundler version switching works (BUNDLE_GEMFILE)
    # - Test isolation is maintained (BUNDLE_APP_CONFIG, etc.)
    # - User settings are respected (BUNDLE_PATH, BUNDLE_USER_CACHE, etc.)
    #
    # NOTE: BUNDLE_LOCKFILE is NOT preserved because:
    # - Bundler automatically infers lockfile from BUNDLE_GEMFILE (e.g., foo.gemfile -> foo.gemfile.lock)
    # - Forcing BUNDLE_LOCKFILE breaks appraisal's ability to create per-gemfile lockfiles
    # - Each appraisal needs its own lockfile, not the root Gemfile.lock
    PRESERVED_BUNDLE_VARS = [
      "BUNDLE_GEMFILE",
      "BUNDLE_APP_CONFIG",
      "BUNDLE_PATH",
      "BUNDLE_USER_CONFIG",
      "BUNDLE_USER_CACHE",
      "BUNDLE_USER_PLUGIN",
      "BUNDLE_IGNORE_FUNDING_REQUESTS",
      "BUNDLE_DISABLE_SHARED_GEMS"
    ].freeze

    PRESERVED_RUNTIME_VARS = [
      "PATH",
      "GEM_HOME",
      "GEM_PATH"
    ].freeze

    def initialize(command, options = {})
      @gemfile = options[:gemfile]
      @env = options.fetch(:env, {})
      @skip_bundle_exec = options.fetch(:skip_bundle_exec, false)
      @command = @skip_bundle_exec ? command : command_starting_with_bundle(command)
    end

    def run
      run_env = test_environment.merge(env)

      if @skip_bundle_exec
        execute(ENV.to_h, run_env)
      else
        clean_env = bundler_env(run_env)
        ensure_bundler_is_available(clean_env)
        ensure_locked_bundler_is_available(clean_env)
        execute(clean_env, run_env)
      end
    end

    private

    # Build an Appraisal subprocess environment from Bundler's explicit env APIs.
    #
    # Bundler.clean_env / Bundler.with_clean_env are removed. Bundler now exposes
    # three related but distinct choices:
    #
    # - Bundler.original_env: the environment before the current Bundler activated.
    #   This is too broad for Appraisal because unrelated original BUNDLE_* values
    #   can leak into the appraisal subprocess.
    # - Bundler.unbundled_env: original_env with Bundler activation removed. This
    #   is the right base because it removes parent Bundler state, RUBYOPT
    #   bundler/setup activation, and arbitrary BUNDLE_* values.
    # - Bundler.with_unbundled_env: the block form of unbundled_env. Appraisal
    #   needs a Hash to pass to Kernel.system and must re-add selected variables,
    #   so the block helper is the wrong shape even though its semantics are close.
    #
    # Starting from unbundled_env would normally remove BUNDLE_GEMFILE,
    # BUNDLE_APP_CONFIG, and related isolation knobs. Appraisal intentionally
    # reintroduces only the variables it owns or must preserve, then sets
    # BUNDLE_GEMFILE and the selected Bundler version for the target subprocess.
    def bundler_env(run_env)
      current_env = ENV.to_h
      clean_env = if defined?(Bundler) && Bundler.respond_to?(:unbundled_env)
        Bundler.unbundled_env.to_h
      elsif defined?(Bundler) && Bundler.respond_to?(:original_env)
        Bundler.original_env.to_h
      else
        current_env.to_h
      end

      # Avoid leaking a global BUNDLE_LOCKFILE into subprocesses.
      clean_env["BUNDLE_LOCKFILE"] = nil

      preserved_vars = PRESERVED_BUNDLE_VARS + PRESERVED_RUNTIME_VARS

      preserved_vars.each do |var|
        clean_env[var] = current_env[var] if current_env[var]
      end

      clean_env["RUBYOPT"] = current_env["RUBYOPT"] if current_env["RUBYOPT"]

      # Remove bundler/setup from RUBYOPT so subprocess doesn't auto-load bundler.
      # Bundler.original_env can also contain RUBYOPT, so strip from the final
      # command environment rather than only from the active process env.
      if clean_env["RUBYOPT"]
        rubyopt = clean_env["RUBYOPT"].split(" ")
        rubyopt.reject! { |opt| opt == "-rbundler/setup" || opt.include?("bundler/setup") }
        clean_env["RUBYOPT"] = rubyopt.join(" ")
        clean_env["RUBYOPT"] = nil if clean_env["RUBYOPT"].empty?
      end

      # Remove Bundler activation markers from the subprocess environment.
      # BUNDLE_BIN_PATH pins the already-active Bundler executable, so keeping
      # it would bypass the BUNDLED WITH version selected below.
      clean_env["BUNDLE_BIN_PATH"] = nil
      clean_env["BUNDLE_VERSION"] = nil
      clean_env["BUNDLER_SETUP"] = nil
      clean_env["BUNDLER_VERSION"] = nil

      run_env.each_pair do |key, value|
        clean_env[key] = value
      end

      clean_env
    end

    def execute(base_env, run_env)
      announce

      process_env = base_env.merge(run_env)
      process_env["BUNDLE_GEMFILE"] = gemfile if gemfile
      if (bundler_version = subprocess_bundler_version(process_env))
        process_env["BUNDLE_VERSION"] = bundler_version
        process_env["BUNDLER_VERSION"] = bundler_version
      end
      process_env["APPRAISAL_INITIALIZED"] = "1"

      exit(1) unless Kernel.system(process_env, command_as_string)
    end

    def ensure_bundler_is_available(process_env)
      rubygems_env = rubygems_command_env(process_env)

      # First ask the actual Bundler executable whether it can boot. In CI,
      # especially on alternate Ruby engines, Bundler may be available as the
      # engine-shipped executable while a manually scrubbed RubyGems spec lookup
      # cannot see it through the current GEM_HOME/GEM_PATH.
      return if system(rubygems_env, "bundle -v > /dev/null 2>&1")

      # Check if any version of bundler is available through RubyGems.
      return if system(rubygems_env, bundler_available_command)

      puts ">> Bundler not found, attempting to install..."
      # If that fails, try to install the latest stable version
      return if system(rubygems_env, "ruby --disable=gems -S gem install bundler")

      puts
      puts <<-ERROR.rstrip
Bundler installation failed.
Please try running:
  `gem install bundler`
manually.
      ERROR
      exit(1)
    end

    def ensure_locked_bundler_is_available(process_env)
      locked_version = locked_bundler_version
      return unless locked_version

      rubygems_env = rubygems_command_env(process_env)

      return if system(rubygems_env, bundler_available_command(locked_version))

      puts ">> Bundler #{locked_version} not found, attempting to install..."
      return if system(rubygems_env, "ruby --disable=gems -S gem install bundler -v #{Shellwords.escape(locked_version)} --no-document")

      puts
      puts <<-ERROR.rstrip
Bundler #{locked_version} installation failed.
Please try running:
  `gem install bundler -v #{locked_version}`
manually.
      ERROR
      exit(1)
    end

    def locked_bundler_version
      return unless gemfile

      lockfile_path = "#{gemfile}.lock"
      return unless File.exist?(lockfile_path)

      lockfile_content = File.read(lockfile_path)
      match = lockfile_content.match(/BUNDLED WITH\s*\n\s*([^\s]+)/)
      match && match[1]
    end

    def subprocess_bundler_version(process_env)
      # Production subprocesses pin Bundler only when the appraisal lockfile
      # says to. Acceptance specs may provide APPRAISAL_TEST_BUNDLER_VERSION so
      # the nested subprocesses use the same isolated Bundler selected by the
      # harness, without changing production behavior.
      locked_bundler_version || process_env["APPRAISAL_TEST_BUNDLER_VERSION"]
    end

    def rubygems_command_env(process_env)
      process_env.dup.tap do |env|
        env["BUNDLE_APP_CONFIG"] = nil
        env["BUNDLE_BIN_PATH"] = nil
        env["BUNDLE_GEMFILE"] = nil
        env["BUNDLE_LOCKFILE"] = nil
        env["BUNDLE_VERSION"] = nil
        env["BUNDLER_SETUP"] = nil
        env["BUNDLER_VERSION"] = nil
        env["RUBYOPT"] = nil
      end
    end

    def bundler_available_command(version = nil)
      requirement = version ? ", Gem::Requirement.new(#{version.inspect})" : ""
      code = <<-RUBY.chomp
        require "rubygems"
        specs = Gem::Specification.find_all_by_name("bundler"#{requirement})
        exit(specs.empty? ? 1 : 0)
      RUBY
      "ruby --disable=gems -e #{Shellwords.escape(code)}"
    end

    def announce
      if gemfile
        puts ">> BUNDLE_GEMFILE=#{gemfile} #{command_as_string}"
      else
        puts ">> #{command_as_string}"
      end
    end

    def command_starts_with_bundle?(original_command)
      if original_command.is_a?(Array)
        original_command.first =~ /^bundle/
      else
        original_command =~ /^bundle/
      end
    end

    def command_starting_with_bundle(original_command)
      if command_starts_with_bundle?(original_command)
        original_command
      elsif original_command.is_a?(Array)
        ["bundle", "exec"] + original_command
      else
        "bundle exec #{original_command}"
      end
    end

    def command_as_string
      if command.is_a?(Array)
        Shellwords.join(command)
      else
        command
      end
    end

    def test_environment
      return {} unless ENV["APPRAISAL_UNDER_TEST"] == "1"

      {
        "GEM_HOME" => ENV["GEM_HOME"],
        "GEM_PATH" => ENV["APPRAISAL_TEST_SYSTEM_GEM_PATH"].to_s
      }
    end
  end
end
