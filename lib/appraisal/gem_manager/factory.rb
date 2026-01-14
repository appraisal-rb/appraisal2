# frozen_string_literal: true

require_relative "bundler_adapter"
require_relative "ore_adapter"

module Appraisal
  module GemManager
    # Factory for creating gem manager adapters.
    # Raises errors for unknown or unavailable gem managers.
    class Factory
      ADAPTERS = {
        "bundler" => BundlerAdapter,
        "ore" => OreAdapter,
      }.freeze

      DEFAULT_MANAGER = "bundler"

      class << self
        # Create a gem manager adapter
        # @param gemfile_path [String] path to the gemfile
        # @param project_root [Pathname] root directory of the project
        # @param manager [String, nil] gem manager name (bundler or ore)
        # @return [Base] gem manager adapter instance
        # @raise [UnknownGemManagerError] if manager is not recognized
        # @raise [OreNotAvailableError] if ore is requested but not installed
        def create(gemfile_path, project_root, manager: nil)
          manager_name = normalize_manager_name(manager)

          adapter_class = ADAPTERS.fetch(manager_name) do
            raise UnknownGemManagerError.new(manager_name, ADAPTERS.keys)
          end

          adapter = adapter_class.new(gemfile_path, project_root)
          adapter.validate_availability!
          adapter
        end

        # List of available gem manager names
        # @return [Array<String>]
        def available_managers
          ADAPTERS.keys
        end

        private

        def normalize_manager_name(manager)
          return DEFAULT_MANAGER if manager.nil? || manager.to_s.strip.empty?

          manager.to_s.strip.downcase
        end
      end
    end
  end
end
