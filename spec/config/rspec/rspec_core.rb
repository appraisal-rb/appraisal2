PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "../../..")).freeze
puts "Using project root: #{PROJECT_ROOT}"
TMP_GEM_ROOT = File.join(PROJECT_ROOT, "tmp", "bundler")
puts "Using tmp gem root: #{TMP_GEM_ROOT}"
TMP_GEM_BUILD = File.join(PROJECT_ROOT, "tmp", "build")
puts "Using tmp gem build: #{TMP_GEM_BUILD}"
ENV["APPRAISAL_UNDER_TEST"] = "1"

RSpec.configure do |config|
  config.raise_errors_for_deprecations!

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.define_derived_metadata(:file_path => %r{spec/acceptance/}) do |metadata|
    metadata[:type] = :acceptance
  end

  config.before :suite do
    FileUtils.rm_rf TMP_GEM_ROOT
    FileUtils.rm_rf TMP_GEM_BUILD
  end
end
