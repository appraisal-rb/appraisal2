# frozen_string_literal: true

module Appraisal
  # Contains methods for various operations
  module Utils
    class << self
      def support_parallel_installation?
        Gem::Version.create(Bundler::VERSION) >= Gem::Version.create("1.4.0.pre.1")
      end

      def support_git_local_installation?
        Gem::Version.create(Bundler::VERSION) > Gem::Version.create("2.4.22")
      end

      # Appraisal needs to print Gemfiles in the oldest Ruby syntax that is supported by Appraisal.
      # Otherwise, a project would not be able to use Appraisal to test compatibility
      #   with older versions of Ruby, which is a core use case for Appraisal.
      def format_string(object, enclosing_object = false)
        case object
        when Hash
          items = object.map do |key, value|
            format_hash_value(key, value)
          end

          if enclosing_object
            "{ #{items.join(", ")} }"
          else
            items.join(", ")
          end
        else
          object.inspect
        end
      end

      # Appraisal needs to print Gemfiles in the oldest Ruby syntax that is supported by Appraisal.
      # This means formatting Hashes as Rockets, until support for Ruby 1.8 is dropped.
      # Regardless of what Ruby is used to generate appraisals,
      #   generated appraisals may need to run on a different Ruby version.
      # Generated appraisals should use a syntax compliant with the oldest supported Ruby version.
      def format_hash_value(key, value)
        key = format_string(key, true)
        value = format_string(value, true)

        "#{key} => #{value}"
      end

      def format_arguments(arguments)
        return if arguments.empty?

        arguments.map { |object| format_string(object, false) }.join(", ")
      end

      def join_parts(parts)
        parts.reject(&:nil?).reject(&:empty?).join("\n\n").rstrip
      end

      def prefix_path(path)
        if path !~ /^(?:\/|\S:)/ && path !~ /^\S+:\/\// && path !~ /^\S+@\S+:/
          cleaned_path = path.gsub(/(^|\/)\.(?:\/|$)/, "\\1")
          File.join("..", cleaned_path)
        else
          path
        end
      end

      def bundler_version
        spec = Gem::Specification.detect { |s| s.name == "bundler" }
        return "2.4.22" unless spec # Fallback for very old systems

        spec.version.to_s
      end
    end
  end
end
