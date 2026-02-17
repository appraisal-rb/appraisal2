# frozen_string_literal: true

require "shellwords"

module Appraisal
  # Executes commands with a clean environment
  class Command
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

    # Provide a clean environment while preserving bundler's version switching capability.
    # This is similar to Bundler's with_original_env but more selective about which
    # BUNDLE_* variables to remove, allowing auto-version-switching to work.
    def with_bundler_env
      # Save current environment
      backup_env = ENV.to_h

      begin
        # Create a clean environment from the original (pre-bundler) state
        # but preserve BUNDLE_GEMFILE which is critical for bundler's auto-switching
        clean_env = Bundler.original_env.to_h

        # Restore BUNDLE_GEMFILE if it was set - bundler needs this to auto-switch versions
        clean_env["BUNDLE_GEMFILE"] = backup_env["BUNDLE_GEMFILE"] if backup_env["BUNDLE_GEMFILE"]

        # Restore BUNDLE_PATH if it was set - commonly used for gem caching between appraisals
        clean_env["BUNDLE_PATH"] = backup_env["BUNDLE_PATH"] if backup_env["BUNDLE_PATH"]

        # Replace environment with our clean version
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
