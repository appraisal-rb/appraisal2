# frozen_string_literal: true

module Appraisal
  module GemManager
    # Abstract base class defining the interface for gem managers.
    # Subclasses must implement all public methods.
    class Base
      attr_reader :gemfile_path, :project_root

      # @param gemfile_path [String] path to the gemfile
      # @param project_root [Pathname] root directory of the project
      def initialize(gemfile_path, project_root)
        @gemfile_path = gemfile_path
        @project_root = project_root
      end

      # Install gems for the given gemfile
      # @param options [Hash] install options (jobs, retry, without, path, etc.)
      # @return [void]
      def install(options = {})
        raise NotImplementedError, "#{self.class}#install must be implemented"
      end

      # Update gems (all or specific gems)
      # @param gems [Array<String>] list of gems to update, empty = all
      # @return [void]
      def update(gems = [])
        raise NotImplementedError, "#{self.class}#update must be implemented"
      end

      # Name of the gem manager for display
      # @return [String]
      def name
        raise NotImplementedError, "#{self.class}#name must be implemented"
      end

      # Check if the gem manager is available on the system
      # @return [Boolean]
      def available?
        raise NotImplementedError, "#{self.class}#available? must be implemented"
      end

      # Validate that the gem manager is available, raising an error if not
      # @raise [OreNotAvailableError] if ore is not available
      # @return [void]
      def validate_availability!
        # Default implementation does nothing (bundler is always available)
      end
    end
  end
end
