# frozen_string_literal: true

# External Libraries
require "active_support/core_ext/string/strip"
require "kettle/test/rspec"
# `kettle/test/rspec` installs harness helpers documented in spec/README.md.
require "rspec/pending_for"
require "rspec/stubbed_env"
require "silent_stream"

# RSpec Support
require "support/dependency_helpers"
Dir[File.join(__dir__, "support/shared_contexts/**/*.rb")].sort.each { |f| require f }

# RSpec Configs
require "debug" if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.7")
require "config/rspec/rspec_block_is_expected"
require "config/rspec/rspec_core"

# Last thing before loading this gem is to setup code coverage
begin
  require "kettle-soup-cover"
  if Kettle::Soup::Cover::DO_COV
    require "simplecov"
    require "kettle/soup/cover/config"
    SimpleCov.start
  end
  #   this next line has a side-effect of running `.simplecov`
rescue LoadError
  # check the error message and re-raise when unexpected
  nil
end

# This library
require "appraisal2"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
# RSpec support that depends on this library
require "support/acceptance_test_helpers"
