require "bundler/gem_tasks" if !Dir[File.join(__dir__, "*.gemspec")].empty?
require "require_bench" if ENV.fetch("REQUIRE_BENCH", "false").casecmp("true") == 0

# Define a base default task early so other files can enhance it.
desc "Default tasks aggregator"
task :default do
  puts "Default task complete."
end

# This gem's tasks
require "appraisal/task"
Appraisal::Task.new

# External gems that define tasks - add here!
require "kettle/dev"

### SPEC TASKS
# For coverage aggregation with SimpleCov merging:
# - Each task uses a unique K_SOUP_COV_COMMAND_NAME so SimpleCov tracks them separately
# - K_SOUP_COV_USE_MERGING=true must be set in .envrc for results to merge
# - K_SOUP_COV_MERGE_TIMEOUT should be set long enough for all tasks to complete
begin
  require "rspec/core/rake_task"

  # kettle-dev creates an RSpec::Core::RakeTask.new(:spec) which has both
  # prerequisites and actions. We will leave that, and the default test task, alone,
  # and use *magic* here.
  Rake::Task[:magic].clear if Rake::Task.task_defined?(:magic)
  desc("Run specs")
  RSpec::Core::RakeTask.new(:magic) do |t|
    t.pattern = "./spec/**/*_spec.rb"
  end

  desc("Set SimpleCov command name for remaining specs")
  task(:set_coverage_command_name) do
    ENV["COVERAGE_GEMS"] = "true"
    ENV["K_SOUP_COV_COMMAND_NAME"] = "Test Coverage"
  end
  Rake::Task[:magic].enhance([:set_coverage_command_name])

  Rake::Task[:coverage].clear if Rake::Task.task_defined?(:coverage)
  desc("Slap magic onto the main coverage task")
  task(:coverage => [:magic])
rescue LoadError
  desc("(stub) spec is unavailable")
  task(:spec) do # rubocop:disable Rake/DuplicateTask
    warn("NOTE: rspec isn't installed, or is disabled for #{RUBY_VERSION} in the current environment")
  end

  desc("(stub) test is unavailable")
  task(:test) do # rubocop:disable Rake/DuplicateTask
    warn("NOTE: rspec isn't installed, or is disabled for #{RUBY_VERSION} in the current environment")
  end
end

### RELEASE TASKS
# Setup stone_checksums
begin
  require "stone_checksums"
rescue LoadError
  desc("(stub) build:generate_checksums is unavailable")
  task("build:generate_checksums") do
    warn("NOTE: stone_checksums isn't installed, or is disabled for #{RUBY_VERSION} in the current environment")
  end
end
