# Changelog

This file documents all notable changes to this project.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
Versioning: [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security

## [3.0.0] - 2025-07-27
- Initial release as hard fork, from [appraisal v3.0.0.rc1](https://github.com/thoughtbot/appraisal/commit/602cdd9b5f8cb8f36992733422f69312b172f427), with many improvements - by @pboling
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
