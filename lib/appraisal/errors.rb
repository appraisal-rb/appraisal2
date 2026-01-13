# frozen_string_literal: true

module Appraisal
  # Raises when Appraisal is unable to locate Appraisals file in the current directory.
  class AppraisalsNotFound < StandardError
    def message
      "Unable to locate 'Appraisals' file in the current directory."
    end
  end

  # Raises when ore-light gem manager is requested but not installed.
  class OreNotAvailableError < ArgumentError
    def message
      "ore-light is not installed or not in PATH. " \
        "Install from: https://github.com/contriboss/ore-light"
    end
  end

  # Raises when an unknown gem manager is requested.
  class UnknownGemManagerError < ArgumentError
    def initialize(manager, available)
      @manager = manager
      @available = available
      super()
    end

    def message
      "Unknown gem manager: '#{@manager}'. Available: #{@available.join(", ")}"
    end
  end
end
