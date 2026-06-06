# frozen_string_literal: true

module Appraisal
  # Lifecycle hooks used by companion gems to extend Appraisal without
  # monkey-patching command or generation internals.
  module Hooks
    class GemfileContext
      attr_accessor :content
      attr_reader :appraisal, :path

      def initialize(appraisal, path, content)
        @appraisal = appraisal
        @path = path
        @content = content
      end
    end

    @gemfile_transforms = []

    class << self
      def transform_gemfile(&block)
        raise ArgumentError, "transform_gemfile requires a block" unless block

        @gemfile_transforms << block
      end

      def run_transform_gemfile(appraisal, path, content)
        context = GemfileContext.new(appraisal, path, content)
        @gemfile_transforms.each do |hook|
          if hook.arity == 1
            result = hook.call(context.content)
          else
            result = hook.call(context.content, context)
          end
          context.content = result unless result.nil?
        end
        context.content
      end

      def reset!
        @gemfile_transforms.clear
      end
    end
  end

  class << self
    def transform_gemfile(&block)
      Hooks.transform_gemfile(&block)
    end
  end
end
