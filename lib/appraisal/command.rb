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
      # Capture BUNDLE_PATH from the current environment before with_original_env scrubs it
      bundle_path = ENV["BUNDLE_PATH"]
      run_env = test_environment.merge(env)

      if @skip_bundle_exec
        execute(run_env)
      else
        Bundler.with_original_env do
          # Restore BUNDLE_PATH if it was set
          ENV["BUNDLE_PATH"] = bundle_path if bundle_path
          ensure_bundler_is_available
          execute(run_env)
        end
      end
    end

    private

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
