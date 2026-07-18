# frozen_string_literal: true

require "shellwords"

require "appraisal/utils"

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
        commands = [install_command(options).join(" ")]

        # Only run check command if not using --without option
        if options["without"].nil? || options["without"].empty?
          commands.unshift(check_command.join(" "))
        end

        command = commands.join(" || ")
        command = path_config_command(options["path"], command) if options["path"]
        env = install_environment(options)
        command_options = {:gemfile => gemfile_path}
        command_options[:env] = env unless env.empty?

        Command.new(command, command_options).run
      end

      def update(gems = [])
        Command.new(update_command(gems), :gemfile => gemfile_path).run
      end

      private

      def check_command
        gemfile_option = "--gemfile='#{gemfile_path}'"
        ["bundle", "check", gemfile_option]
      end

      def install_command(options = {})
        gemfile_option = "--gemfile='#{gemfile_path}'"
        ["bundle", "install", gemfile_option, bundle_options(options)].compact
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
          options_strings << "--#{flag} #{val}"
        end

        options_strings.join(" ") if options_strings != []
      end

      def path_config_command(path, command)
        relative_path = project_root.join(path)
        "bundle config set --local path #{Shellwords.escape(relative_path.to_s)} && (#{command})"
      end

      def install_environment(options)
        env = {}

        if options["path"].nil? && Bundler.settings[:path]
          env["BUNDLE_DISABLE_SHARED_GEMS"] = "1"
        end

        env
      end
    end
  end
end
