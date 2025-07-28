# frozen_string_literal: true

# NOTE: Disable this RuboCop rule to use RUBY_VERSION to determine how to get the gem's version
# rubocop:disable Gemspec/RubyVersionGlobalsUsage
gem_version =
  if RUBY_VERSION >= "3.1"
    # Loading version into an anonymous module allows version.rb to get code coverage from SimpleCov!
    # See: https://github.com/simplecov-ruby/simplecov/issues/557#issuecomment-2630782358
    Module.new.tap { |mod| Kernel.load("lib/appraisal/version.rb", mod) }::Appraisal::VERSION
  else
    # TODO: Remove this hack once support for Ruby 3.0 and below is removed
    Kernel.load("lib/appraisal/version.rb")
    g_ver = Appraisal::VERSION
    Appraisal.send(:remove_const, :VERSION)
    g_ver
  end
# rubocop:enable Gemspec/RubyVersionGlobalsUsage

Gem::Specification.new do |spec|
  spec.name = "appraisal2"
  spec.version = gem_version
  spec.authors = ["Peter Boling", "Joe Ferris", "Prem Sichanugrist"]
  spec.email = ["galtzo@floss.com"]

  # Linux distros often package gems and securely certify them independent
  #   of the official RubyGem certification process. Allowed via ENV["SKIP_GEM_SIGNING"]
  # Ref: https://gitlab.com/oauth-xx/version_gem/-/issues/3
  # Hence, only enable signing if `SKIP_GEM_SIGNING` is not set in ENV.
  # See CONTRIBUTING.md
  unless ENV.include?("SKIP_GEM_SIGNING")
    user_cert = "certs/#{ENV.fetch("GEM_CERT_USER", ENV["USER"])}.pem"
    cert_file_path = File.join(__dir__, user_cert)
    cert_chain = cert_file_path.split(",")
    cert_chain.select! { |fp| File.exist?(fp) }
    if cert_file_path && cert_chain.any?
      spec.cert_chain = cert_chain
      if $PROGRAM_NAME.end_with?("gem") && ARGV[0] == "build"
        spec.signing_key = File.join(Gem.user_home, ".ssh", "gem-private_key.pem")
      end
    end
  end

  spec.summary = "Find out what your Ruby gems are worth"
  spec.description = 'Appraisal2 integrates with bundler and rake to test your library against different versions of dependencies in repeatable scenarios called "appraisals."'
  gh_mirror = "https://github.com/appraisal-rb/#{spec.name}"
  gl_homepage = "https://gitlab.com/appraisal-rb/#{spec.name}"
  spec.homepage = gl_homepage
  spec.license = "MIT"
  spec.required_ruby_version = ">= 1.8.7"

  spec.metadata["homepage_uri"] = "https://#{spec.name}.galtzo.com/"
  spec.metadata["source_code_uri"] = "#{gh_mirror}/releases/tag/v#{spec.version}"
  spec.metadata["changelog_uri"] = "#{gl_homepage}/-/blob/v#{spec.version}/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{gl_homepage}/-/issues"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/#{spec.name}/#{spec.version}"
  spec.metadata["wiki_uri"] = "#{gl_homepage}/-/wiki"
  spec.metadata["funding_uri"] = "https://github.com/sponsors/pboling"
  spec.metadata["news_uri"] = "https://www.railsbling.com/tags/#{spec.name}"
  spec.metadata["discord_uri"] = "https://discord.gg/3qme4XHNKN"
  spec.metadata["rubygems_mfa_required"] = "true"

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

  spec.add_dependency("bundler", ">= 1.17.3")  # Last version supporting Ruby 1.8.7
  spec.add_dependency("rake", ">= 10")         # Last version supporting Ruby 1.8.7
  spec.add_dependency("thor", ">= 0.14")       # Last version supporting Ruby 1.8.7 && Rails 3

  # NOTE: It is preferable to list development dependencies in the gemspec due to increased
  #       visibility and discoverability on RubyGems.org.
  #       However, development dependencies in gemspec will install on
  #       all versions of Ruby that will run in CI.
  #       This gem, and its runtime dependencies, will install on Ruby down to 1.8.7.
  #       This gem, and its development dependencies, will install on Ruby down to 2.3.x.
  #       This is because in CI easy installation of Ruby, via setup-ruby, is for >= 2.3.
  #       Thus, dev dependencies in gemspec must have
  #
  #       required_ruby_version ">= 2.3" (or lower)
  #
  #       Development dependencies that require strictly newer Ruby versions should be in a "gemfile",
  #       and preferably a modular one (see gemfiles/modular/*.gemfile).

  # Release Tasks
  spec.add_development_dependency("stone_checksums", "~> 1.0") # Ruby >= 2.2.0

  # Testing
  spec.add_development_dependency("activesupport", ">= 3.2.21")
  spec.add_development_dependency("rspec", "~> 3.13")                               # Ruby >= 0
  spec.add_development_dependency("rspec-block_is_expected", "~> 1.0", ">= 1.0.6")  # Ruby >= 1.8.7
  spec.add_development_dependency("rspec_junit_formatter", "~> 0.6")                # Ruby >= 2.3.0, for GitLab Test Result Parsing
  spec.add_development_dependency("rspec-pending_for", "~> 0.1", ">= 0.1.17")       # Ruby >= 1.8.7
end
