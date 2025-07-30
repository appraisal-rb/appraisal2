# frozen_string_literal: true

# External Libraries
require "active_support/core_ext/string/strip"
require "rspec/pending_for"
require "silent_stream"

# RSpec Support
require "support/dependency_helpers"

# RSpec Configs
require "config/byebug"
require "config/rspec/rspec_block_is_expected"
require "config/rspec/rspec_core"

# Last thing before loading this gem is to setup code coverage
begin
  # This does not require "simplecov", but
  require "kettle-soup-cover"
  #   this next line has a side-effect of running `.simplecov`
  require "simplecov" if defined?(Kettle::Soup::Cover) && Kettle::Soup::Cover::DO_COV
rescue LoadError
  nil
end

# This library
require "appraisal2"

# RSpec support that depends on this library
require "support/acceptance_test_helpers"
