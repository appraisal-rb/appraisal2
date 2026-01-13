# frozen_string_literal: true

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

        if Bundler.settings[:path]
          env = {"BUNDLE_DISABLE_SHARED_GEMS" => "1"}
          Command.new(command, :env => env).run
        else
          Command.new(command).run
        end
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
        ["bundle", "update", *gems].compact
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

        path = full_options.delete("path")
        if path
          relative_path = project_root.join(options["path"])
          options_strings << "--path #{relative_path}"
        end

        full_options.each do |flag, val|
          options_strings << "--#{flag} #{val}"
        end

        options_strings.join(" ") if options_strings != []
      end
    end
  end
end
