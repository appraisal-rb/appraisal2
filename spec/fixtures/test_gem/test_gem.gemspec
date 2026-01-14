# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "test_gem"
  spec.version = "1.0.0"
  spec.authors = ["Test Author"]
  spec.email = ["test@example.com"]
  spec.summary = "A minimal test gem for appraisal2 acceptance tests"
  spec.description = "This gem is used only for testing appraisal2 functionality"
  spec.homepage = "https://github.com/appraisal-rb/appraisal2"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 1.8.7"

  spec.files = ["lib/test_gem.rb"]
  spec.require_paths = ["lib"]

  # No dependencies - keep it minimal
end
