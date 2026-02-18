# frozen_string_literal: true

require "shellwords"

module Appraisal
  # Executes commands with a clean environment
  class Command
    attr_reader :command, :env, :gemfile

    # BUNDLE_* environment variables that must be preserved for proper bundler operation
    # and test isolation. These are preserved when using with_bundler_env to ensure:
    # - Bundler version switching works (BUNDLE_GEMFILE)
    # - Test isolation is maintained (BUNDLE_APP_CONFIG, etc.)
    # - User settings are respected (BUNDLE_PATH, BUNDLE_USER_CACHE, etc.)
    #
    # NOTE: BUNDLE_LOCKFILE is NOT preserved because:
    # - Bundler automatically infers lockfile from BUNDLE_GEMFILE (e.g., foo.gemfile -> foo.gemfile.lock)
    # - Forcing BUNDLE_LOCKFILE breaks appraisal's ability to create per-gemfile lockfiles
    # - Each appraisal needs its own lockfile, not the root Gemfile.lock
    PRESERVED_BUNDLE_VARS = %w[
      BUNDLE_GEMFILE
      BUNDLE_APP_CONFIG
      BUNDLE_PATH
      BUNDLE_BIN_PATH
      BUNDLE_USER_CONFIG
      BUNDLE_USER_CACHE
      BUNDLE_USER_PLUGIN
      BUNDLE_IGNORE_FUNDING_REQUESTS
      BUNDLE_DISABLE_SHARED_GEMS
    ].freeze

    PRESERVED_RUNTIME_VARS = %w[
      PATH
      GEM_PATH
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
        execute(run_env)
      else
        # For bundler version switching to work in modern bundler (2.2+),
        # we need to preserve certain BUNDLE_* environment variables.
        # However, we still need to isolate from the parent's bundler state
        # to avoid conflicts.
        #
        # Solution: Use a selective environment approach instead of with_original_env,
        # which strips all BUNDLE_* variables and breaks version switching.
        with_bundler_env do
          ensure_bundler_is_available
          ensure_locked_bundler_is_available
          execute(run_env)
        end
      end
    end

    private

    # Provide a clean environment while preserving bundler's version switching capability
    # and test isolation settings.
    #
    # The current Ruby process has bundler activated, which adds bundler/setup to RUBYOPT.
    # When we run a subprocess, we need to remove that activation so the subprocess bundler
    # can start fresh. However, we keep all test isolation variables intact.
    def with_bundler_env
      backup_env = ENV.to_h

      begin
        clean_env = if Bundler.respond_to?(:original_env)
          Bundler.original_env.to_h
        else
          backup_env.to_h
        end

        # Avoid leaking a global BUNDLE_LOCKFILE into subprocesses.
        clean_env.delete("BUNDLE_LOCKFILE")

        preserved_vars = PRESERVED_BUNDLE_VARS + PRESERVED_RUNTIME_VARS

        preserved_vars.each do |var|
          clean_env[var] = backup_env[var] if backup_env[var]
        end

        # Remove bundler/setup from RUBYOPT so subprocess doesn't auto-load bundler
        if backup_env["RUBYOPT"]
          rubyopt = backup_env["RUBYOPT"].split(" ")
          rubyopt.reject! { |opt| opt == "-rbundler/setup" || opt.include?("bundler/setup") }
          clean_env["RUBYOPT"] = rubyopt.join(" ") unless rubyopt.empty?
        end

        # Remove bundler activation markers from the subprocess environment
        clean_env.delete("BUNDLER_SETUP")
        clean_env.delete("BUNDLER_VERSION")

        ENV.replace(clean_env)

        yield
      ensure
        ENV.replace(backup_env)
      end
    end

    def execute(run_env)
      announce

      ENV["BUNDLE_GEMFILE"] = gemfile
      ENV["APPRAISAL_INITIALIZED"] = "1"
      run_env.each_pair do |key, value|
        ENV[key] = value
      end

      exit(1) unless Kernel.system(command_as_string)
    end

    def ensure_bundler_is_available
      # Check if any version of bundler is available
      return if system(%(gem list --silent -i bundler))

      puts ">> Bundler not found, attempting to install..."
      # If that fails, try to install the latest stable version
      return if system("gem install bundler")

      puts
      puts <<-ERROR.rstrip
Bundler installation failed.
Please try running:
  `gem install bundler`
manually.
      ERROR
      exit(1)
    end

    def ensure_locked_bundler_is_available
      # Bundler 2.2+ already switches to the lockfile version automatically.
      # Only install the locked version as a fallback for older Bundler releases.
      return if bundler_handles_lockfile_version?

      locked_version = locked_bundler_version
      return unless locked_version

      return if system(%(gem list --silent -i bundler -v "#{locked_version}"))

      puts ">> Bundler #{locked_version} not found, attempting to install..."
      return if system("gem install bundler -v #{Shellwords.escape(locked_version)} --no-document")

      puts
      puts <<-ERROR.rstrip
Bundler #{locked_version} installation failed.
Please try running:
  `gem install bundler -v #{locked_version}`
manually.
      ERROR
      exit(1)
    end

    def bundler_handles_lockfile_version?
      return false unless defined?(Bundler::VERSION)

      Gem::Version.new(Bundler::VERSION) >= Gem::Version.new("2.2.0")
    end

    def locked_bundler_version
      return unless gemfile

      lockfile_path = "#{gemfile}.lock"
      return unless File.exist?(lockfile_path)

      lockfile_content = File.read(lockfile_path)
      match = lockfile_content.match(/BUNDLED WITH\s*\n\s*([^\s]+)/)
      match && match[1]
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
        %w[bundle exec] + original_command
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
        "GEM_PATH" => "",
      }
    end
  end
end
