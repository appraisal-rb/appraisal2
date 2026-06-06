# frozen_string_literal: true

module Appraisal
  # Lifecycle hooks used by companion gems to extend Appraisal without
  # monkey-patching command or generation internals.
  module Hooks
    @after_write_gemfile = []

    class << self
      def after_write_gemfile(&block)
        raise ArgumentError, "after_write_gemfile requires a block" unless block

        @after_write_gemfile << block
      end

      def run_after_write_gemfile(appraisal, path)
        @after_write_gemfile.each do |hook|
          hook.call(appraisal, path)
        end
      end

      def reset!
        @after_write_gemfile.clear
      end
    end
  end

  class << self
    def after_write_gemfile(&block)
      Hooks.after_write_gemfile(&block)
    end
  end
end
