# frozen_string_literal: true

module Appraisal
  # Lifecycle hooks used by companion gems to extend Appraisal without
  # monkey-patching command or generation internals.
  module Hooks
    GEMFILE_TRANSFORM_MUTEX = Mutex.new
    GEMFILE_TRANSFORMS = [].freeze

    class GemfileContext
      attr_accessor :content
      attr_reader :appraisal, :path

      def initialize(appraisal, path, content)
        @appraisal = appraisal
        @path = path
        @content = content
      end
    end

    class << self
      def transform_gemfile(&block)
        raise ArgumentError, "transform_gemfile requires a block" unless block

        GEMFILE_TRANSFORM_MUTEX.synchronize do
          set_gemfile_transforms(gemfile_transforms + [block])
        end
      end

      def run_transform_gemfile(appraisal, path, content)
        context = GemfileContext.new(appraisal, path, content)
        gemfile_transforms.each do |hook|
          result = if hook.arity == 1
            hook.call(context.content)
          else
            hook.call(context.content, context)
          end
          context.content = result unless result.nil?
        end
        context.content
      end

      def reset!
        GEMFILE_TRANSFORM_MUTEX.synchronize do
          set_gemfile_transforms([])
        end
      end

      private

      def gemfile_transforms
        ::Appraisal::Hooks.const_get(:GEMFILE_TRANSFORMS)
      end

      def set_gemfile_transforms(transforms)
        ::Appraisal::Hooks.__send__(:remove_const, :GEMFILE_TRANSFORMS)
        ::Appraisal::Hooks.const_set(:GEMFILE_TRANSFORMS, transforms.freeze)
      end
    end
  end

  class << self
    def transform_gemfile(&block)
      Hooks.transform_gemfile(&block)
    end
  end
end
