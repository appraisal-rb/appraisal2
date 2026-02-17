# Changelog

This file documents all notable changes to this project.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
Versioning: [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Test for bundler handling with pre-existing appraisal lockfiles
  - Added acceptance test that verifies appraisal correctly handles `gemfiles/*.gemfile.lock` files with `BUNDLED WITH` specified
  - Test validates that:
    - Appraisal gemfiles with pre-created lockfiles install correctly
    - Lockfiles preserve the `BUNDLED WITH` section reporting which bundler version was used
    - The bundler version in the lockfile is correctly maintained during installation
  - Note: Full bundler version-switching testing would require pre-installing multiple bundler versions in CI, which is not practical. The core bundler version switching is tested via the main fix for `with_bundler_env` preserving necessary environment variables.

### Changed

```

### Removed

### Fixed

- Support bundler's automatic version switching for modern bundler versions (2.2+)
  - Bundler can automatically detect and switch to the version specified in `Gemfile.lock` (or appraisal lockfiles) via `BUNDLED WITH`
  - Previously, `with_original_env` would strip ALL bundler-related environment variables including `BUNDLE_GEMFILE`, preventing bundler from detecting version mismatches
  - Now uses selective environment cleanup: removes only bundler's internal activation state (`BUNDLER_SETUP`, `BUNDLER_VERSION`, bundler references in `RUBYOPT`/`RUBYLIB`) while preserving all test isolation and user configuration
  - This approach:
    - Allows bundler to correctly detect and switch versions based on `BUNDLED WITH` in lockfiles
    - Preserves all critical configuration (`BUNDLE_APP_CONFIG`, `BUNDLE_PATH`, `BUNDLE_USER_CACHE`, etc.)
    - Maintains test isolation and prevents global config pollution
    - Enables users to commit locked appraisal lockfiles for stable, repeatable CI builds
  - This fix maintains backward compatibility with legacy bundler versions while enabling version switching for modern bundler

### Security

## [3.0.5] - 2026-02-14

- TAG: [v3.0.5][3.0.5t]
- COVERAGE: 89.67% -- 703/784 lines in 27 files
- BRANCH COVERAGE: 82.99% -- 122/147 branches in 27 files
- 43.03% documented

### Added

- Documentation of `BUNDLE_PATH` for caching gems

### Fixed

- Restore support for `BUNDLE_PATH` environment variable which regressed in  `v3.0.3`
  - `BUNDLE_PATH` is explicitly preserved to support CI environments that rely on it for gem caching.

## [3.0.4] - 2026-02-10

- TAG: [v3.0.4][3.0.4t]
- COVERAGE: 89.67% -- 703/784 lines in 27 files
- BRANCH COVERAGE: 83.45% -- 121/145 branches in 27 files
- 43.03% documented

### Changed

- Documentation cleanup
- Fixed typos in docs

## [3.0.3] - 2026-02-07

- TAG: [v3.0.3][3.0.3t]
- COVERAGE: 89.67% -- 703/784 lines in 27 files
- BRANCH COVERAGE: 83.45% -- 121/145 branches in 27 files
- 43.03% documented

### Added

- New CLI specs for testing named appraisal commands with options
- Shared RSpec contexts for mocking gem managers (`BundlerAdapter` and `OreAdapter`) to facilitate faster unit testing

### Changed

- Improved documentation for using `install` and `update` commands with named appraisals and options
- Added examples showing correct command order: `appraisal <NAME> install --gem-manager=ore`
- Enhanced "Using Ore with Appraisal2" section with named appraisal examples
- Refactored `OreAdapter` to use the `Appraisal::Command` abstraction, unifying command execution across gem managers
- Enhanced `Appraisal::Command` with a `:skip_bundle_exec` option to support standalone executables like `ore`. When this option is enabled, `Command` now also skips `Bundler.with_original_env` wrapping and `ensure_bundler_is_available` checks, avoiding unnecessary Bundler overhead.
- Significantly optimized unit tests in `cli_spec.rb` and `appraisal_spec.rb` by using gem manager mocks, reducing execution time from seconds to milliseconds

### Fixed

- Removed `Dir.chdir` into `gemfiles/` directory before running `ore` commands.
- Improved robustness of acceptance tests in isolated environments, especially on Ruby HEAD.
  - Updated `setup_gem_path_for_local_install` to correctly include `TMP_GEM_ROOT` and more reliably detect the parent project's `vendor/bundle` gem directory.
  - Added a fallback to remote installation in `build_default_gemfile` if `bundle install --local` fails, preventing test failures when dependencies are missing from the local cache.
- Improved robustness against Bundler installation failures in CI, especially on Ruby HEAD.
  - `Appraisal::Command` and acceptance tests now only attempt to install Bundler if no version is currently available, avoiding unnecessary and potentially failing version-specific installations.
  - Removed aggressive Bundler version matching and "downgrading" logic that stripped prerelease suffixes.
- **BREAKING BUG FIX**: Fixed CLI to properly handle `install` and `update` commands when targeting a specific appraisal with options
  - Previously `appraisal <NAME> install --gem-manager=ore` would incorrectly try to run the Unix `install` command
  - Now correctly invokes the appraisal install/update methods with proper option parsing
  - Fixes error: `/usr/bin/install: unrecognized option '--gem-manager=ore'`
- Fixed argument parsing in CLI where repeated values could be mis-parsed as gem names instead of option values (e.g., `appraisal <NAME> update ore -g ore`).
- Improved shell-escaping handling in `Appraisal::Command` and updated acceptance tests to match the more robust output
- Standardized on `clean_name` (underscores) for gemfile paths across the test suite for consistency

## [3.0.2] - 2026-02-06

- TAG: [v3.0.2][3.0.2t]
- COVERAGE: 77.11% -- 603/782 lines in 27 files
- BRANCH COVERAGE: 83.96% -- 89/106 branches in 27 files
- 43.03% documented

### Added

- funding documentation
- Ruby version compatibility badges for v1.8 - v2.2, v3.4, v4.0
- Appraisal & CI workflow for ruby v3.4

## [3.0.1] - 2026-02-06

- TAG: [v3.0.1][3.0.1t]
- COVERAGE: 77.11% -- 603/782 lines in 27 files
- BRANCH COVERAGE: 83.96% -- 89/106 branches in 27 files
- 43.03% documented

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

[Unreleased]: https://github.com/appraisal-rb/appraisal2/compare/v3.0.5...HEAD
[3.0.5]: https://github.com/appraisal-rb/appraisal2/compare/v3.0.4...v3.0.5
[3.0.5t]: https://github.com/appraisal-rb/appraisal2/releases/tag/v3.0.5
[3.0.4]: https://github.com/appraisal-rb/appraisal2/compare/v3.0.3...v3.0.4
[3.0.4t]: https://github.com/appraisal-rb/appraisal2/releases/tag/v3.0.4
[3.0.3]: https://github.com/appraisal-rb/appraisal2/compare/v3.0.2...v3.0.3
[3.0.3t]: https://github.com/appraisal-rb/appraisal2/releases/tag/v3.0.3
[3.0.2]: https://github.com/appraisal-rb/appraisal2/compare/v3.0.1...v3.0.2
[3.0.2t]: https://github.com/appraisal-rb/appraisal2/releases/tag/v3.0.2
[3.0.1]: https://github.com/appraisal-rb/appraisal2/compare/v3.0.0...v3.0.1
[3.0.1t]: https://github.com/appraisal-rb/appraisal2/releases/tag/v3.0.1
[3.0.0]:  https://github.com/appraisal-rb/appraisal2/compare/602cdd9b5f8cb8f36992733422f69312b172f427...v3.0.0
