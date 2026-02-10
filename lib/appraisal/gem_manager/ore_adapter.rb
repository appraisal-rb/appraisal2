# frozen_string_literal: true

require_relative "base"

module Appraisal
  module GemManager
    # Ore-light adapter for gem management operations.
    # Ore-light is a fast, Go-based alternative to Bundler for gem installation.
    # See: https://github.com/contriboss/ore-light
    class OreAdapter < Base
      ORE_EXECUTABLE = "ore"

      def name
        "ore"
      end

      def available?
        system("which #{ORE_EXECUTABLE} > /dev/null 2>&1")
      end

      def validate_availability!
        raise OreNotAvailableError unless available?
      end

      def install(options = {})
        validate_availability!

        lockfile = "#{gemfile_path}.lock"

        # Run ore lock first if lockfile doesn't exist
        unless File.exist?(lockfile)
          lock_command = [ORE_EXECUTABLE, "lock", "-gemfile", gemfile_path]
          run_ore_command(lock_command)
        end

        command = install_command(options)
        run_ore_command(command)
      end

      def update(gems = [])
        validate_availability!

        command = update_command(gems)
        run_ore_command(command)
      end

      private

      def install_command(options = {})
        cmd = [ORE_EXECUTABLE, "install"]

        # Map bundler options to ore options
        # Ore uses -workers instead of --jobs
        jobs = options["jobs"]
        cmd << "-workers=#{jobs}" if jobs && jobs > 1

        # Ore uses -without with comma-separated groups
        without = options["without"]
        if without && !without.empty?
          # Convert space-separated to comma-separated
          groups = without.split(/\s+/).join(",")
          cmd << "-without=#{groups}"
        end

        # Ore uses -vendor instead of --path
        path = options["path"]
        if path
          relative_path = project_root.join(path)
          cmd << "-vendor=#{relative_path}"
        end

        # Ore uses -lockfile to specify the lockfile path
        cmd << "-lockfile=#{gemfile_path}.lock"

        # Note: Ore does not support --retry, so we ignore that option

        cmd
      end

      def update_command(gems)
        cmd = [ORE_EXECUTABLE, "update", "-gemfile", gemfile_path]
        cmd.concat(gems) if gems.any?
        cmd
      end

      def run_ore_command(command)
        Command.new(command, :gemfile => gemfile_path, :skip_bundle_exec => true).run
      end
    end
  end
end
