source "https://rubygems.org"

gemspec

platform :mri do
  # Debugging
  gem "byebug", ">= 11"

  # Dev Console - Binding.pry - Irb replacement
  gem "pry", "~> 0.14"                     # ruby >= 2.0
end

# This here to make sure appraisal works with Rails 3.0.0.
gem "thor", "~> 0.14.0"

# Ruby version specific dependencies
ruby_version = Gem::Version.new(RUBY_VERSION)
if ruby_version < Gem::Version.new("1.9")
  eval File.read("Gemfile-1.8")
elsif ruby_version < Gem::Version.new("2.1")
  eval File.read("Gemfile-2.0")
elsif ruby_version < Gem::Version.new("2.2")
  eval File.read("Gemfile-2.1")
elsif ruby_version < Gem::Version.new("2.7")
  # Std Lib extractions
  gem "benchmark", "~> 0.4" # Removed from Std Lib in Ruby 3.5
else
  # Ruby >= 2.7 we can run style / lint checks via rubocop-gradual with rubocop-lts rules for Ruby 1.8+.
  # This means we can develop on modern Ruby but remain compatible with ancient Ruby.
  eval_gemfile "gemfiles/modular/style.gemfile"
end
