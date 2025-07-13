# frozen_string_literal: true

# TODO: Switch to require_relative once support for Ruby < 2 is dropped.
# require_relative "lib/appraisal/version"

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "appraisal/version"

Gem::Specification.new do |spec|
  spec.name = "appraisal2"
  spec.version = Appraisal::VERSION.dup
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["Joe Ferris", "Prem Sichanugrist"]
  spec.email = ["jferris@thoughtbot.com", "prem@thoughtbot.com"]
  spec.homepage = "http://github.com/appraisal-rb/appraisal2"
  spec.summary = "Find out what your Ruby gems are worth"
  spec.description = 'Appraisal integrates with bundler and rake to test your library against different versions of dependencies in repeatable scenarios called "appraisals."'
  spec.license = "MIT"

  # Specify which files are part of the released package.
  spec.files = Dir[
    # Splats (alphabetical)
    "lib/**/*.rb",
  ]
  # Automatically included with gem package, no need to list again in files.
  spec.extra_rdoc_files = Dir[
    # Files (alphabetical)
    "CHANGELOG.md",
    "CODE_OF_CONDUCT.md",
    "CONTRIBUTING.md",
    "LICENSE.txt",
    "README.md",
    "SECURITY.md",
  ]
  spec.rdoc_options += [
    "--title",
    "#{spec.name} - #{spec.summary}",
    "--main",
    "CHANGELOG.md",
    "CODE_OF_CONDUCT.md",
    "CONTRIBUTING.md",
    "LICENSE.txt",
    "README.md",
    "SECURITY.md",
    "--line-numbers",
    "--inline-source",
    "--quiet",
  ]
  spec.require_paths = ["lib"]
  # bin/ is scripts, in any available language, for development of this specific gem
  # exe/ is for ruby scripts that will ship with this gem to be used by other tools
  spec.bindir = "exe"
  # files listed are relative paths from bindir above.
  spec.executables = [
    "appraisal",
  ]

  spec.required_ruby_version = ">= 1.8.7"

  spec.add_dependency("bundler", ">= 1.17.3")  # Last version supporting Ruby 1.8.7
  spec.add_dependency("rake", ">= 10")         # Last version supporting Ruby 1.8.7
  spec.add_dependency("thor", ">= 0.14")       # Last version supporting Ruby 1.8.7 && Rails 3

  spec.add_development_dependency("activesupport", ">= 3.2.21")
  spec.add_development_dependency("rspec", "~> 3.13")
  spec.add_development_dependency("rspec-block_is_expected", "~> 1.0", ">= 1.0.6")
  spec.add_development_dependency("rspec-pending_for", "~> 0.1", ">= 0.1.17")
end
