# frozen_string_literal: true

require "shellwords"

module Appraisal
  # Executes commands with a clean environment
  class Command
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

    attr_reader :command, :env, :gemfile

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
          execute(run_env)
        end
      end
    end

    private

    # Provide a clean environment while preserving bundler's version switching capability
    # and test isolation settings.
    #
    # Instead of using Bundler.original_env (which removes all bundler activation state),
    # we selectively remove only the variables that cause conflicts, while preserving
    # the test isolation and user settings that have been carefully configured.
    #
    # This allows bundler to detect and switch versions based on BUNDLED WITH in lockfiles.
    def with_bundler_env
      # Variables that should be REMOVED to avoid bundler activation conflicts
      # These are bundler's internal state from the current Ruby process
      vars_to_remove = %w[
        BUNDLER_SETUP
        BUNDLER_VERSION
      ]

      # Variables that should be REMOVED if they point to the current appraisal2 setup
      # (to avoid bundler being confused about which gemfile is active)
      bundler_state_vars = %w[
        RUBYOPT
        RUBYLIB
      ]

      backup_env = ENV.to_h

      begin
        # Start with current environment (preserves all test isolation and user settings)
        clean_env = backup_env.to_h

        # Remove bundler's internal activation state
        vars_to_remove.each { |var| clean_env.delete(var) }

        # Remove bundler path manipulation from RUBYOPT and RUBYLIB to let
        # the subprocess bundler work cleanly with the target gemfile
        if clean_env["RUBYOPT"]
          rubyopt = clean_env["RUBYOPT"].split(" ")
          rubyopt.reject! { |opt| opt.include?("bundler/setup") }
          if rubyopt.empty?
            clean_env.delete("RUBYOPT")
          else
            clean_env["RUBYOPT"] = rubyopt.join(" ")
          end
        end

        if clean_env["RUBYLIB"]
          rubylib = clean_env["RUBYLIB"].split(File::PATH_SEPARATOR)
          # Remove bundler's lib directory
          rubylib.reject! { |path| path.include?("bundler") }
          if rubylib.empty?
            clean_env.delete("RUBYLIB")
          else
            clean_env["RUBYLIB"] = rubylib.join(File::PATH_SEPARATOR)
          end
        end

        # Replace environment
        ENV.replace(clean_env)

        yield
      ensure
        # Always restore the full environment
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
