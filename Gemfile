#### IMPORTANT #######################################################
# Gemfile is for local development ONLY; Gemfile is NOT loaded in CI #
####################################################### IMPORTANT ####
# On CI we only need the gemspecs' dependencies (including development dependencies).
# Exceptions, if any, such as for Appraisals, are in gemfiles/*.gemfile

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }
git_source(:gitlab) { |repo_name| "https://gitlab.com/#{repo_name}" }

latest_ruby_version = Gem::Version.create("3.4")
current_ruby_version = Gem::Version.create(RUBY_VERSION)
current_minor_ruby = Gem::Version.create(current_ruby_version.segments[0..1].join("."))
is_ci = ENV.fetch("CI", "false").casecmp("true") == 0

gemspec

### Debugging
if !is_ci && ENV.fetch("DEBUG", "false").casecmp("true") == 0
  platform :mri do
    # Debugging - Ensure ENV["DEBUG"] == "true" to use debuggers within spec suite
    if current_ruby_version < Gem::Version.new("2.7")
      # Use byebug in code
      gem "byebug", ">= 11"
      # Dev Console - Binding.pry - Irb replacement
      gem "pry", "~> 0.14"                     # ruby >= 2.0
    else
      # Use binding.break, binding.b, or debugger in code
      # eval_gemfile "gemfiles/modular/debug.gemfile"
    end
  end
end

if current_ruby_version < Gem::Version.new("1.9")
  eval_gemfile("gemfiles/modular/ruby-1-8.gemfile")
elsif current_ruby_version < Gem::Version.new("2.0")
  eval_gemfile("gemfiles/modular/ruby-1-9.gemfile")
elsif current_ruby_version < Gem::Version.new("2.1")
  eval_gemfile("gemfiles/modular/ruby-2-0.gemfile")
elsif current_ruby_version < Gem::Version.new("2.2")
  eval_gemfile("gemfiles/modular/ruby-2-1.gemfile")
elsif current_ruby_version < Gem::Version.new("2.3")
  eval_gemfile("gemfiles/modular/ruby-2-2.gemfile")
elsif current_ruby_version < Gem::Version.new("2.4")
  eval_gemfile("gemfiles/modular/ruby-2-3.gemfile")
elsif current_ruby_version < Gem::Version.new("2.5")
  eval_gemfile("gemfiles/modular/ruby-2-4.gemfile")
elsif current_ruby_version < Gem::Version.new("2.6")
  eval_gemfile("gemfiles/modular/ruby-2-5.gemfile")
elsif current_ruby_version < Gem::Version.new("2.7")
  eval_gemfile("gemfiles/modular/ruby-2-6.gemfile")
elsif current_ruby_version < Gem::Version.new("3.0")
  eval_gemfile("gemfiles/modular/ruby-2-7.gemfile")
elsif current_ruby_version < Gem::Version.new("3.1")
  eval_gemfile("gemfiles/modular/ruby-3-0.gemfile")
elsif current_ruby_version < Gem::Version.new("3.2")
  eval_gemfile("gemfiles/modular/ruby-3-1.gemfile")
elsif current_ruby_version < Gem::Version.new("3.3")
  eval_gemfile("gemfiles/modular/ruby-3-2.gemfile")
elsif current_ruby_version < Gem::Version.new("3.4")
  eval_gemfile("gemfiles/modular/ruby-3-3.gemfile")
elsif current_minor_ruby.eql?(latest_ruby_version)
  # Only runs on the latest Ruby
  eval_gemfile("gemfiles/modular/current.gemfile")

  if is_ci
    if ENV.fetch("DEP_HEADS", "false").casecmp("true") == 0
      eval_gemfile("gemfiles/modular/dep_heads.gemfile")
    elsif ENV.fetch("AUDIT_GEMS", "false").casecmp("true") == 0
      eval_gemfile("gemfiles/modular/audit.gemfile")
    elsif ENV.fetch("COVERAGE_GEMS", "false").casecmp("true") == 0
      eval_gemfile("gemfiles/modular/coverage.gemfile")
    elsif ENV.fetch("STYLE_GEMS", "false").casecmp("true") == 0
      eval_gemfile("gemfiles/modular/style.gemfile")
    else
      eval_gemfile("gemfiles/modular/current.gemfile")
    end
  else
    ### Security Audit
    eval_gemfile("gemfiles/modular/audit.gemfile")
    ### Test Coverage
    eval_gemfile("gemfiles/modular/coverage.gemfile")
    ### Documentation
    eval_gemfile("gemfiles/modular/documentation.gemfile")
    ### Linting
    eval_gemfile("gemfiles/modular/style.gemfile")
  end
elsif current_minor_ruby > latest_ruby_version
  eval_gemfile("gemfiles/modular/heads.gemfile")
  # Std Lib extractions
  gem "benchmark", "~> 0.4" # Removed from Std Lib in Ruby 3.5
else
  warn "Unhandled Ruby version: #{RUBY_VERSION}"
end
