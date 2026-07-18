# frozen_string_literal: true

require "thor"
require "fileutils"
require "thread"

module Appraisal
  class CLI < Thor
    MINIMUM_PARALLEL_BUNDLER_VERSION = Gem::Version.new("2.1.0")

    default_task :install
    map ["-v", "--version"] => "version"
    map "generate-install" => "generate_install"
    map "generate-update" => "generate_update"

    class_option "gem-manager",
      :aliases => "-g",
      :type => :string,
      :default => "bundler",
      :desc => "Gem manager to use for install/update (bundler or ore)"
    class_option "appraisal-jobs",
      :aliases => "-n",
      :type => :numeric,
      :banner => "SIZE",
      :desc => "Process appraisals in parallel using the given number of workers."

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

    desc "install", "Resolve and install dependencies for each generated appraisal gemfile"
    method_option "jobs",
      :aliases => "j",
      :type => :numeric,
      :default => 1,
      :banner => "SIZE",
      :desc => "Pass the given parallel job count to the selected gem manager."
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
      install_appraisals(appraisals, install_options, appraisal_jobs(options))
    end

    desc "generate-install", "Generate gemfiles, then resolve and install dependencies for each appraisal"
    method_option "jobs",
      :aliases => "j",
      :type => :numeric,
      :default => 1,
      :banner => "SIZE",
      :desc => "Pass the given parallel job count to the selected gem manager."
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
    def generate_install
      appraisal_list = appraisals
      generate_appraisals(appraisal_list, appraisal_jobs(options))
      install_appraisals(appraisal_list, install_options, appraisal_jobs(options))
    end

    desc "generate", "Generate a gemfile for each appraisal"
    def generate
      generate_appraisals(appraisals, appraisal_jobs(options))
    end

    desc "clean", "Remove all generated gemfiles and lockfiles from gemfiles folder"
    def clean
      FileUtils.rm_f(Dir["gemfiles/*.{gemfile,gemfile.lock}"])
    end

    desc "update [LIST_OF_GEMS]", "Update dependencies for each generated appraisal gemfile"
    def update(*gems)
      update_appraisals(appraisals, gems, update_options, appraisal_jobs(options))
    end

    desc "generate-update [LIST_OF_GEMS]", "Generate gemfiles, then update dependencies for each appraisal"
    def generate_update(*gems)
      appraisal_list = appraisals
      generate_appraisals(appraisal_list, appraisal_jobs(options))
      update_appraisals(appraisal_list, gems, update_options, appraisal_jobs(options))
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

    def appraisals
      AppraisalFile.new.appraisals
    end

    def generate_appraisals(appraisal_list, jobs)
      each_appraisal(appraisal_list, jobs) do |appraisal|
        appraisal.write_gemfile
      end
    end

    def install_appraisals(appraisal_list, install_options, jobs)
      each_appraisal(appraisal_list, jobs) do |appraisal|
        appraisal.install(install_options.dup)
        appraisal.relativize
      end
    end

    def update_appraisals(appraisal_list, gems, update_options, jobs)
      each_appraisal(appraisal_list, jobs) do |appraisal|
        appraisal.update(gems, update_options.dup)
      end
    end

    def each_appraisal(appraisal_list, jobs)
      jobs = worker_count(jobs, appraisal_list.length)
      return appraisal_list.each { |appraisal| yield(appraisal) } if jobs <= 1

      queue = Queue.new
      errors = []
      mutex = Mutex.new

      appraisal_list.each { |appraisal| queue << appraisal }
      jobs.times { queue << nil }

      # rubocop:disable ThreadSafety/NewThread
      threads = Array.new(jobs) do
        Thread.new do
          while (appraisal = queue.pop)
            begin
              yield(appraisal)
            rescue Exception => error # rubocop:disable Lint/RescueException
              mutex.synchronize { errors << error }
            end
          end
        end
      end
      # rubocop:enable ThreadSafety/NewThread
      threads.each(&:join)

      raise errors.first unless errors.empty?
    end

    def worker_count(jobs, item_count)
      jobs = jobs.to_i
      jobs = 1 if jobs < 1
      jobs = 1 unless parallel_appraisals_supported?
      return jobs if item_count.zero?

      [jobs, item_count].min
    end

    def parallel_appraisals_supported?
      # Parallel install/update workers depend on Appraisal::Command being able
      # to build independent Bundler subprocess environments. Bundler 2.1 is the
      # floor for the modern original_env/unbundled_env API split that replaced
      # clean_env, so older Bundler versions keep the historical serial path.
      bundler_version = Gem::Specification.find_all_by_name("bundler").map(&:version).max
      return false unless bundler_version

      bundler_version >= MINIMUM_PARALLEL_BUNDLER_VERSION
    end

    def appraisal_jobs(command_options)
      command_options["appraisal-jobs"] || command_options[:appraisal_jobs] || ENV["APPRAISAL_JOBS"] || 2
    end

    def install_options
      options.to_h.reject { |key, _value| key.to_s == "appraisal-jobs" }
    end

    def update_options
      gem_manager = options["gem-manager"] || options[:gem_manager]
      gem_manager ? {:gem_manager => gem_manager} : {}
    end

    def method_missing(name, *args)
      case name.to_s
      when "generate-install"
        return generate_install
      when "generate-update"
        return generate_update(*args)
      end

      matching_appraisal = AppraisalFile.new.appraisals.detect do |appraisal|
        appraisal.name == name.to_s
      end

      if matching_appraisal
        # If no arguments were passed to method_missing, check ARGV
        # This handles cases where Thor doesn't pass arguments
        actual_args = (args.empty? && ARGV.any?) ? ARGV.dup : args

        # Check if the first argument is an appraisal subcommand.
        if actual_args.first == "generate"
          matching_appraisal.write_gemfile
        elsif actual_args.first == "install"
          # Extract Thor options from the remaining arguments
          # Filter out the command name and pass options to install
          filtered_args = actual_args[1..-1] || []
          # Parse the options ourselves since Thor isn't parsing them here
          parsed_options = parse_external_options(filtered_args)

          # Also include the class-level gem_manager option if provided
          # Thor consumes class_option before calling method_missing, so check both places
          gem_manager = options["gem-manager"] || options[:gem_manager]
          parsed_options[:gem_manager] = gem_manager if gem_manager && !parsed_options.key?(:gem_manager)

          matching_appraisal.install(parsed_options)
          matching_appraisal.relativize
        elsif actual_args.first == "generate-install"
          filtered_args = actual_args[1..-1] || []
          parsed_options = parse_external_options(filtered_args)

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
        elsif actual_args.first == "generate-update"
          filtered_args = actual_args[1..-1] || []
          gems, parsed_options = extract_gems_and_options(filtered_args)

          gem_manager = options["gem-manager"] || options[:gem_manager]
          parsed_options[:gem_manager] = gem_manager if gem_manager && !parsed_options.key?(:gem_manager)

          matching_appraisal.write_gemfile
          matching_appraisal.update(gems, parsed_options)
        else
          # Run as an external command
          Command.new(actual_args, :gemfile => matching_appraisal.gemfile_path).run
        end
      else
        each_appraisal(AppraisalFile.new.appraisals, appraisal_jobs(options)) do |appraisal|
          Command.new(ARGV, :gemfile => appraisal.gemfile_path).run
        end
      end
    end

    def parse_external_options(args)
      options = {}
      skip_next = false

      args.each_with_index do |arg, index|
        if skip_next
          skip_next = false
          next
        end

        case arg
        when /^--gem-manager=(.+)$/
          options[:gem_manager] = Regexp.last_match(1)
        when /^-g$/
          # Next arg should be the value
          options[:gem_manager] = args[index + 1]
          skip_next = true
        when /^--jobs=(\d+)$/
          options[:jobs] = Regexp.last_match(1).to_i
        when /^-j(\d+)$/
          options[:jobs] = Regexp.last_match(1).to_i
        when /^-j$/
          options[:jobs] = args[index + 1].to_i
          skip_next = true
        when /^--appraisal-jobs=\d+$/
          nil
        when /^--appraisal-jobs$/
          skip_next = true
        when /^-n\d+$/
          nil
        when /^-n$/
          skip_next = true
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
      skip_next = false

      args.each_with_index do |arg, index|
        if skip_next
          skip_next = false
          next
        end

        case arg
        when /^--gem-manager=(.+)$/
          options[:gem_manager] = Regexp.last_match(1)
        when /^-g$/
          # Next arg should be the value
          options[:gem_manager] = args[index + 1]
          skip_next = true
        when /^--appraisal-jobs$/
          skip_next = true
        when /^-n$/
          skip_next = true
        when /^-/
          # Other options are not gems, but we don't handle them all here
          # For now, just skip them to be safe if they start with -
          # Actually, the original code only handled -g specifically.
          # If we see another option we don't know, it's probably not a gem name.
          # But Thor usually handles them. Here we are in method_missing.
        else
          gems << arg
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
