# frozen_string_literal: true

require_relative "errors"
require_relative "gem_manager/factory"

module Appraisal
  # Gem manager abstraction layer.
  # Supports multiple gem managers (bundler, ore-light) via adapter pattern.
  module GemManager
  end
end
