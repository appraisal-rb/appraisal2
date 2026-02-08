# frozen_string_literal: true

require "thor"
require "fileutils"

module Appraisal
  class CLI < Thor
    default_task :install
    map ["-v", "--version"] => "version"

    class_option "gem-manager",
      :aliases => "-g",
      :type => :string,
      :default => "bundler",
      :desc => "Gem manager to use for install/update (bundler or ore)"

    class << self
      # Override help command to print out usage
      def help(shell, subcommand = false)
        shell.say(strip_heredoc(<<-HELP))
          Appraisal: Find out what your Ruby gems are worth.

          Usage:
            appraisal [APPRAISAL_NAME] EXTERNAL_COMMAND

            If APPRAISAL_NAME is given, only run that EXTERNAL_COMMAND against the given
            appraisal, otherwise it runs the EXTERNAL_COMMAND against all appraisals.
        HELP

        if File.exist?("Appraisals")
          shell.say
          shell.say("Available Appraisal(s):")

          AppraisalFile.each do |appraisal|
            shell.say("  - #{appraisal.name}")
          end
        end

        shell.say

        super
      end

      def exit_on_failure?
        true
      end

      private

      def strip_heredoc(string)
        indent = string.scan(/^[ \t]*(?=\S)/).min.size || 0
        string.gsub(/^[ \t]{#{indent}}/, "")
      end
    end

    desc "install", "Resolve and install dependencies for each appraisal"
    method_option "jobs",
      :aliases => "j",
      :type => :numeric,
      :default => 1,
      :banner => "SIZE",
      :desc => "Install gems in parallel using the given number of workers."
    method_option "retry",
      :type => :numeric,
      :default => 1,
      :desc => "Retry network and git requests that have failed"
    method_option "without",
      :banner => "GROUP_NAMES",
      :desc => "A space-separated list of groups referencing gems to skip " \
        "during installation. Bundler will remember this option."
    method_option "full-index",
      :type => :boolean,
      :desc => "Run bundle install with the " \
        "full-index argument."
    method_option "path",
      :type => :string,
      :desc => "Install gems in the specified directory. " \
        "Bundler will remember this option."

    def install
      invoke(:generate, [], {})

      install_options = options.to_h
      AppraisalFile.each do |appraisal|
        appraisal.install(install_options)
        appraisal.relativize
      end
    end

    desc "generate", "Generate a gemfile for each appraisal"
    def generate
      AppraisalFile.each do |appraisal|
        appraisal.write_gemfile
      end
    end

    desc "clean", "Remove all generated gemfiles and lockfiles from gemfiles folder"
    def clean
      FileUtils.rm_f(Dir["gemfiles/*.{gemfile,gemfile.lock}"])
    end

    desc "update [LIST_OF_GEMS]", "Remove all generated gemfiles and lockfiles, resolve, and install dependencies again"
    def update(*gems)
      invoke(:generate, [], {})

      gem_manager = options["gem-manager"] || options[:gem_manager]
      update_options = gem_manager ? { :gem_manager => gem_manager } : {}
      AppraisalFile.each do |appraisal|
        appraisal.update(gems, update_options)
      end
    end

    desc "list", "List the names of the defined appraisals"
    def list
      AppraisalFile.new.appraisals.each { |appraisal| puts appraisal.name }
    end

    desc "version", "Display the version and exit"
    def version
      puts "Appraisal2 #{VERSION}"
    end

    private

    def method_missing(name, *args)
      matching_appraisal = AppraisalFile.new.appraisals.detect do |appraisal|
        appraisal.name == name.to_s
      end

      if matching_appraisal
        # If no arguments were passed to method_missing, check ARGV
        # This handles cases where Thor doesn't pass arguments
        actual_args = args.empty? && ARGV.any? ? ARGV.dup : args

        # Check if the first argument is a Thor command (install or update)
        if actual_args.first == "install"
          # Extract Thor options from the remaining arguments
          # Filter out the command name and pass options to install
          filtered_args = actual_args[1..-1] || []
          # Parse the options ourselves since Thor isn't parsing them here
          parsed_options = parse_external_options(filtered_args)

          # Also include the class-level gem_manager option if provided
          # Thor consumes class_option before calling method_missing, so check both places
          gem_manager = options["gem-manager"] || options[:gem_manager]
          parsed_options[:gem_manager] = gem_manager if gem_manager && !parsed_options.key?(:gem_manager)

          matching_appraisal.write_gemfile
          matching_appraisal.install(parsed_options)
          matching_appraisal.relativize
        elsif actual_args.first == "update"
          # Extract gems and options
          filtered_args = actual_args[1..-1] || []
          gems, parsed_options = extract_gems_and_options(filtered_args)

          # Also include the class-level gem_manager option if provided
          gem_manager = options["gem-manager"] || options[:gem_manager]
          parsed_options[:gem_manager] = gem_manager if gem_manager && !parsed_options.key?(:gem_manager)

          matching_appraisal.update(gems, parsed_options)
        else
          # Run as an external command
          Command.new(actual_args, :gemfile => matching_appraisal.gemfile_path).run
        end
      else
        AppraisalFile.each do |appraisal|
          Command.new(ARGV, :gemfile => appraisal.gemfile_path).run
        end
      end
    end

    def parse_external_options(args)
      options = {}
      args.each do |arg|
        case arg
        when /^--gem-manager=(.+)$/
          options[:gem_manager] = Regexp.last_match(1)
        when /^-g$/
          # Next arg should be the value
          idx = args.index(arg)
          options[:gem_manager] = args[idx + 1] if idx && args[idx + 1]
        when /^--jobs=(\d+)$/
          options[:jobs] = Regexp.last_match(1).to_i
        when /^-j(\d+)$/
          options[:jobs] = Regexp.last_match(1).to_i
        when /^--retry=(\d+)$/
          options[:retry] = Regexp.last_match(1).to_i
        when /^--without=(.+)$/
          options[:without] = Regexp.last_match(1)
        when /^--path=(.+)$/
          options[:path] = Regexp.last_match(1)
        when /^--full-index$/
          options[:full_index] = true
        end
      end
      options
    end

    def extract_gems_and_options(args)
      gems = []
      options = {}

      args.each do |arg|
        case arg
        when /^--gem-manager=(.+)$/
          options[:gem_manager] = Regexp.last_match(1)
        when /^-g$/
          # Next arg should be the value
          idx = args.index(arg)
          options[:gem_manager] = args[idx + 1] if idx && args[idx + 1]
        else
          # If it's not an option, it's a gem name (unless it's the value after -g)
          prev_arg = args[args.index(arg) - 1] if args.index(arg) && args.index(arg) > 0
          gems << arg unless prev_arg == "-g"
        end
      end

      [gems, options]
    end

    def respond_to_missing?(name, include_private = false)
      appraisals = AppraisalFile.new.appraisals
      appraisals.any? { |appraisal| appraisal.name == name.to_s } || super
    rescue AppraisalsNotFound
      super
    end
  end
end
