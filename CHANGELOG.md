# Changelog

This file documents all notable changes to this project.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
Versioning: [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Support for [ore-light](https://github.com/contriboss/ore-light) as an alternative gem manager via `--gem-manager=ore` CLI option
  - New `GemManager::OreAdapter` class implementing ore-light integration
  - New `GemManager::BundlerAdapter` class (extracted from existing bundler logic)
  - New `GemManager::Factory` class for creating gem manager adapters
  - New `GemManager::Base` abstract base class defining the gem manager interface
  - New `OreNotAvailableError` and `UnknownGemManagerError` error classes
  - Acceptance tests for ore install and update commands (tagged with `:ore` metadata for conditional execution)
  - Unit tests for all gem manager adapter classes
  - README documentation for ore usage, including installation, CLI options, and example workflows
- New `-g` / `--gem-manager` CLI option to select gem manager (bundler or ore) for install/update commands
- New `Appraisal::Customize.reset!` class method to reset customization state (useful for testing)
- Improved test coverage from 66.7% to 76.4% line coverage, 61.5% to 77.4% branch coverage
  - New unit tests for `BundlerDSL` class (including APPRAISAL_INDENTER variations)
  - New unit tests for `Command` class
  - New unit tests for `Conditional` class
  - New unit tests for `Source` class
  - New unit tests for `Git` class
  - New unit tests for `Path` class
  - New unit tests for `OrderedHash` class
  - New unit tests for `Dependency` class
  - New unit tests for `Group` class
  - New unit tests for `Platform` class
  - New unit tests for `GemManager::Factory` class
  - New unit tests for error classes (`AppraisalsNotFound`, `OreNotAvailableError`, `UnknownGemManagerError`)
  - Enhanced `DependencyList` tests with edge cases
  - Enhanced `Gemfile` tests with load/run/dup edge cases
- Added documentation on hostile takeover of RubyGems
  - https://dev.to/galtzo/hostile-takeover-of-rubygems-my-thoughts-5hlo
- CLI configs for RuboCop, RubyGems, YARD, and JRuby (for local development only)

### Changed

- Improved test isolation for acceptance tests to prevent modification of parent project's Gemfile.lock
  - Added `BUNDLE_APP_CONFIG` isolation to prevent reading/writing parent's `.bundle/config`
  - Added explicit `BUNDLE_GEMFILE` prefix to all bundle commands in tests
  - Added `BUNDLE_LOCKFILE` environment variable to explicitly control where lockfiles are written
  - Set `BUNDLE_IGNORE_FUNDING_REQUESTS` and `BUNDLE_DISABLE_SHARED_GEMS` for cleaner test output
  - Added `BUNDLE_USER_CACHE` isolation to prevent polluting user's gem cache
  - Fixed overly broad `File` stubs in unit tests that interfered with RSpec error formatting
  - Changed `bundle_without_spec.rb` to use `skip_for` instead of `pending_for` to prevent test setup from running on unsupported Ruby versions (which was polluting the project Gemfile.lock with test gems)
- YARD CLI config switch from custom Kramdown support to yard-fence

### Deprecated

### Removed

### Fixed

- Fixed `BundlerAdapter#install` not passing `gemfile_path` to `Command.new`, which caused bundler to potentially write to the wrong Gemfile.lock when `Bundler.with_original_env` reset the environment
- Fixed ore-light adapter path resolution: ore now runs from the gemfile's directory so relative path dependencies resolve correctly (ore resolves paths relative to working directory, not gemfile location)
- Fixed Thor `invoke(:generate, [])` call in `update` command to pass empty options hash, preventing argument leakage

### Security

- Ore adapter now uses array-based command construction for `Kernel.system` calls instead of string interpolation, preventing potential shell injection vulnerabilities

## [3.0.0] - 2025-07-28
- Initial release as a hard fork of [appraisal v3.0.0.rc1](https://github.com/thoughtbot/appraisal/commit/602cdd9b5f8cb8f36992733422f69312b172f427) with many improvements - by @pboling
  - support for `eval_gemfile`
  - support for Ruby 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6 (all removed, or planned-to-be, in thoughtbot's `appraisal`)
    - NOTE: The [setup-ruby GH Action](https://github.com/ruby/setup-ruby) only ships support for Ruby 2.3+, so older Rubies are no longer tested in CI. Compatibility is assumed thanks to [![Enforced Code Style Linter](https://img.shields.io/badge/code_style_%26_linting-rubocop--lts-34495e.svg?plastic&logo=ruby&logoColor=white)](https://github.com/rubocop-lts/rubocop-lts) enforcing the syntax for the oldest supported Ruby, which is Ruby v1.8. File a bug if you find something broken.
  - Support for JRuby 9.4+
  - updated and improved documentation
  - maintainability tracked with QLTY.sh and the reek gem
  - code coverage tracked with Coveralls, QLTY.sh, and the kettle-soup-cover gem
  - other minor fixes and improvements

[Unreleased]: https://gitlab.com/appraisal-rb/appraisal2/-/compare/v3.0.0...HEAD
[3.0.0]:  https://gitlab.com/appraisal-rb/appraisal2/-/compare/602cdd9b5f8cb8f36992733422f69312b172f427...v3.0.0
