# frozen_string_literal: true

require "appraisal/utils"
require "set"

require_relative "base"

module Appraisal
  module GemManager
    # Bundler adapter for gem management operations.
    # This is the default gem manager and is always available.
    class BundlerAdapter < Base
      DEFAULT_INSTALL_OPTIONS = {"jobs" => 1}.freeze

      def name
        "bundler"
      end

      def available?
        true # Bundler is always available (it's a dependency of appraisal2)
      end

      def install(options = {})
        env = install_environment(options)
        command_options = {:env => env, :gemfile => gemfile_path}

        if options["path"]
          Command.new(path_config_command(options["path"]), :gemfile => gemfile_path).run
        end

        unless install_options_require_execution?(options)
          check_options = command_options.merge(:allow_failure => true)
          return if Command.new(check_command, check_options).run
        end

        Command.new(install_command(options), command_options).run
      end

      def update(gems = [])
        Command.new(update_command(gems), :gemfile => gemfile_path).run
      end

      private

      def check_command
        ["bundle", "check", "--gemfile", gemfile_path]
      end

      def install_options_require_execution?(options)
        return true if options["path"]
        return true if options["without"] && !options["without"].empty?
        return true if options["full-index"]
        return true if options.key?("jobs") && options["jobs"] != 1
        return true if options.key?("retry") && options["retry"] != 1

        false
      end

      def install_command(options = {})
        command = ["bundle", "install", "--gemfile", gemfile_path]
        bundle_options(options).each { |argument| command.push(argument) }
        command
      end

      def update_command(gems)
        gems = Array(gems).compact
        return full_update_command if gems.empty?

        ["bundle", "update", *gems]
      end

      def full_update_command
        return ["bundle", "update", "--all"] if Utils.support_bundle_update_all?

        ["bundle", "update"]
      end

      def bundle_options(options)
        full_options = DEFAULT_INSTALL_OPTIONS.dup.merge(options)
        options_strings = []

        jobs = full_options.delete("jobs")
        if jobs > 1
          if Utils.support_parallel_installation?
            options_strings << "--jobs=#{jobs}"
          else
            warn("Your current version of Bundler does not support parallel installation. Please " \
              "upgrade Bundler to version >= 1.4.0, or invoke `appraisal` without `--jobs` option.")
          end
        end

        full_options.delete("path")

        full_options.each do |flag, val|
          option_value = val.is_a?(Set) ? val.to_a.join(" ") : String(val)
          options_strings.push("--#{flag}", option_value)
        end

        options_strings
      end

      def path_config_command(path)
        relative_path = project_root.join(path)
        ["bundle", "config", "set", "--local", "path", relative_path.to_s]
      end

      def install_environment(options)
        env = {"BUNDLE_JOBS" => DEFAULT_INSTALL_OPTIONS.fetch("jobs").to_s}

        if options["path"].nil? && Bundler.settings[:path]
          env["BUNDLE_DISABLE_SHARED_GEMS"] = "1"
        end

        env["BUNDLE_JOBS"] = options["jobs"].to_s if options["jobs"].to_i > 1 && Utils.support_parallel_installation?

        env
      end
    end
  end
end
