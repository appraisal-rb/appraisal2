[![Galtzo FLOSS Logo by Aboling0, CC BY-SA 4.0][🖼️galtzo-i]][🖼️galtzo-discord] [![Appraisal2 Logo by Aboling0, CC BY-SA 4.0][🖼️appraisal2-i]][🖼️appraisal2] [![ruby-lang Logo, Yukihiro Matsumoto, Ruby Visual Identity Team, CC BY-SA 2.5][🖼️ruby-lang-i]][🖼️ruby-lang]

[🖼️galtzo-i]: https://logos.galtzo.com/assets/images/galtzo-floss/avatar-192px.svg
[🖼️galtzo-discord]: https://discord.gg/3qme4XHNKN
[🖼️appraisal2-i]: https://logos.galtzo.com/assets/images/appraisal-rb/appraisal2/avatar-192px.svg
[🖼️appraisal2]: https://github.com/appraisal-rb/appraisal2
[🖼️ruby-lang-i]: https://logos.galtzo.com/assets/images/ruby-lang/avatar-192px.svg
[🖼️ruby-lang]: https://github.com/ruby-lang

# 🔍️ Appraisal2

> Find out what my gems are worth!

- You, possibly

[![Version][👽versioni]][👽version] [![License: MIT][📄license-img]][📄license-ref] [![Downloads Rank][👽dl-ranki]][👽dl-rank] [![Open Source Helpers][👽oss-helpi]][👽oss-help] [![Depfu][🔑depfui♻️]][🔑depfu] [![Coveralls Test Coverage][🔑coveralls-img]][🔑coveralls] [![QLTY Test Coverage][🔑qlty-covi]][🔑qlty-cov] [![QLTY Maintainability][🔑qlty-mnti]][🔑qlty-mnt] [![CI Heads][🚎3-hd-wfi]][🚎3-hd-wf] [![CI Runtime Dependencies @ HEAD][🚎12-crh-wfi]][🚎12-crh-wf] [![CI Current][🚎11-c-wfi]][🚎11-c-wf] [![Deps Locked][🚎13-🔒️-wfi]][🚎13-🔒️-wf] [![Deps Unlocked][🚎14-🔓️-wfi]][🚎14-🔓️-wf] [![CI Test Coverage][🚎2-cov-wfi]][🚎2-cov-wf] [![CI Style][🚎5-st-wfi]][🚎5-st-wf]

---

[![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Buy me a coffee][🖇buyme-small-img]][🖇buyme] [![Donate on Polar][🖇polar-img]][🖇polar] [![Donate to my FLOSS or refugee efforts at ko-fi.com][🖇kofi-img]][🖇kofi] [![Donate to my FLOSS or refugee efforts using Patreon][🖇patreon-img]][🖇patreon]

<details>
    <summary>👣 How will this project approach the September 2025 hostile takeover of RubyGems? 🚑️</summary>

I've summarized my thoughts in [this blog post](https://dev.to/galtzo/hostile-takeover-of-rubygems-my-thoughts-5hlo).

</details>

## 🌻 Synopsis

Appraisal2 integrates with bundler and rake to test your library against
different versions of dependencies in repeatable scenarios called "appraisals."
Appraisal2 is designed to make it easy to check for regressions in your library
without interfering with day-to-day development using Bundler.

Appraisal2 is a hard fork of the venerable appraisal gem,
which thoughtbot maintained for many years.
Many thanks to [thoughtbot](https://github.com/thoughtbot/),
and [Joe Ferris](https://github.com/jferris), the original author!

Appraisal2 adds:

- support for `eval_gemfile`
- support for [ORE](https://github.com/contriboss/ore-light) as an alternative gem manager (faster than bundler!)
- support for Ruby 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6 (all removed, or planned-to-be, in thoughtbot's `appraisal`)
  - NOTE: The [setup-ruby GH Action](https://github.com/ruby/setup-ruby) only ships support for Ruby 2.3+, so older Rubies are no longer tested in CI. Compatibility is assumed thanks to [![Enforced Code Style Linter][💎rlts-img]][💎rlts] enforcing the syntax for the oldest supported Ruby, which is Ruby v1.8. File a bug if you find something broken.
- Support for JRuby 9.4+
- updated and improved documentation
- many other fixes and improvements. See [CHANGELOG](CHANGELOG.md) for details.

## 💡 Info you can shake a stick at

| Tokens to Remember      | [![Gem name][⛳️name-img]][⛳️gem-name] [![Gem namespace][⛳️namespace-img]][⛳️gem-namespace]                                                                                                                                                                                                                                                                                                                                                                          |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Works with JRuby        | [![JRuby 9.4 Compat][💎jruby-9.4i]][🚎10-j9.4-wf] [![JRuby 10.0 Compat][💎jruby-c-i]][🚎11-c-wf] [![JRuby HEAD Compat][💎jruby-headi]][🚎3-hd-wf]                                                                                                                                                                                                                                                                                                                   |
| Works with Truffle Ruby | [![Truffle Ruby 24.1 Compat][💎truby-c-i]][🚎11-c-wf]                                                                                                                                                                                                                                                                                                                                                                                                               |
| Works with MRI Ruby 3   | [![Ruby 3.0 Compat][💎ruby-3.0i]][🚎4-r3.0-wf] [![Ruby 3.1 Compat][💎ruby-3.1i]][🚎4-r3.1-wf] [![Ruby 3.2 Compat][💎ruby-3.2i]][🚎4-r3.2-wf] [![Ruby 3.3 Compat][💎ruby-3.3i]][🚎4-r3.3-wf] [![Ruby 3.4 Compat][💎ruby-c-i]][🚎11-c-wf] [![Ruby HEAD Compat][💎ruby-headi]][🚎3-hd-wf]                                                                                                                                                                              |
| Works with MRI Ruby 2   | [![Ruby 2.3 Compat][💎ruby-2.3i]][🚎1-r2.3-wf] [![Ruby 2.4 Compat][💎ruby-2.4i]][🚎1-r2.4-wf] [![Ruby 2.5 Compat][💎ruby-2.5i]][🚎1-r2.5-wf] [![Ruby 2.6 Compat][💎ruby-2.6i]][🚎1-r2.6-wf] [![Ruby 2.7 Compat][💎ruby-2.7i]][🚎1-r2.7-wf]                                                                                                                                                                                                                          |
| Source                  | [![Source on GitLab.com][📜src-gl-img]][📜src-gl] [![Source on CodeBerg.org][📜src-cb-img]][📜src-cb] [![Source on Github.com][📜src-gh-img]][📜src-gh] [![The best SHA: dQw4w9WgXcQ!][🧮kloc-img]][🧮kloc]                                                                                                                                                                                                                                                         |
| Documentation           | [![Current release on RubyDoc.info][📜docs-cr-rd-img]][🚎yard-current] [![YARD on Galtzo.com][📜docs-head-rd-img]][🚎yard-head] [![BDFL Blog][🚂bdfl-blog-img]][🚂bdfl-blog] [![Wiki][📜wiki-img]][📜wiki]                                                                                                                                                                                                                                                          |
| Compliance              | [![License: MIT][📄license-img]][📄license-ref] [![📄ilo-declaration-img]][📄ilo-declaration] [![Security Policy][🔐security-img]][🔐security] [![Contributor Covenant 2.1][🪇conduct-img]][🪇conduct] [![SemVer 2.0.0][📌semver-img]][📌semver]                                                                                                                                                                                                                    |
| Style                   | [![Enforced Code Style Linter][💎rlts-img]][💎rlts] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog] [![Gitmoji Commits][📌gitmoji-img]][📌gitmoji]                                                                                                                                                                                                                                                                                              |
| Support                 | [![Live Chat on Discord][✉️discord-invite-img]][✉️discord-invite] [![Get help from me on Upwork][👨🏼‍🏫expsup-upwork-img]][👨🏼‍🏫expsup-upwork] [![Get help from me on Codementor][👨🏼‍🏫expsup-codementor-img]][👨🏼‍🏫expsup-codementor]                                                                                                                                                                                                                       |
| Enterprise Support      | [![Get help from me on Tidelift][🏙️entsup-tidelift-img]][🏙️entsup-tidelift]<br/>💡Subscribe for support guarantees covering _all_ FLOSS dependencies!<br/>💡Tidelift is part of [Sonar][🏙️entsup-tidelift-sonar]!<br/>💡Tidelift pays maintainers to maintain the software you depend on!<br/>📊`@`Pointy Haired Boss: An [enterprise support][🏙️entsup-tidelift] subscription is "[never gonna let you down][🧮kloc]", and *supports* open source maintainers! |
| Comrade BDFL 🎖️        | [![Follow Me on LinkedIn][💖🖇linkedin-img]][💖🖇linkedin] [![Follow Me on Ruby.Social][💖🐘ruby-mast-img]][💖🐘ruby-mast] [![Follow Me on Bluesky][💖🦋bluesky-img]][💖🦋bluesky] [![Contact BDFL][🚂bdfl-contact-img]][🚂bdfl-contact] [![My technical writing][💖💁🏼‍♂️devto-img]][💖💁🏼‍♂️devto]                                                                                                                                                              |
| `...` 💖                | [![Find Me on WellFound:][💖✌️wellfound-img]][💖✌️wellfound] [![Find Me on CrunchBase][💖💲crunchbase-img]][💖💲crunchbase] [![My LinkTree][💖🌳linktree-img]][💖🌳linktree] [![More About Me][💖💁🏼‍♂️aboutme-img]][💖💁🏼‍♂️aboutme] [🧊][💖🧊berg] [🐙][💖🐙hub]  [🛖][💖🛖hut] [🧪][💖🧪lab]                                                                                                                                                                   |

## ✨ Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add appraisal2

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install appraisal2

### In a RubyGem library

In your package's `.gemspec`:

    spec.add_development_dependency "appraisal2"

Note that gems must be bundled in the global namespace. Bundling gems to a
local location or vendoring plugins is not fully supported. If you do not want to
pollute the global namespace, one alternative is
[RVM's Gemsets](http://rvm.io/gemsets).

### 🔒 Secure Installation

<details>
  <summary>For Medium or High Security Installations</summary>

`appraisal2` is cryptographically signed, and has verifiable [SHA-256 and SHA-512][💎SHA_checksums] checksums by
[stone_checksums][💎stone_checksums]. Be sure the gem you install hasn’t been tampered with
by following the instructions below.

Add my public key (if you haven’t already, expires 2045-04-29) as a trusted certificate:

```console
gem cert --add <(curl -Ls https://raw.github.com/appraisal-rb/appraisal2/main/certs/pboling.pem)
```

You only need to do that once.  Then proceed to install with:

```console
gem install appraisal2 -P MediumSecurity
```

The `MediumSecurity` trust profile will verify signed gems, but allow the installation of unsigned dependencies.

This is necessary because not all of `appraisal2`’s dependencies are signed, so we cannot use `HighSecurity`.

If you want to up your security game full-time:

```console
bundle config set --global trust-policy MediumSecurity
```

NOTE: Be prepared to track down certs for signed gems and add them the same way you added mine.

</details>

## 🔧 Basic Setup

Setting up appraisal2 requires an `Appraisals` file (similar to a `Gemfile`) in
your project root, named "Appraisals" (note the case), and some slight changes
to your project's `Rakefile`.

An `Appraisals` file consists of several appraisal definitions. An appraisal
definition is simply a list of gem dependencies. For example, to test with a
few versions of Rails:

    appraise "rails-3" do
      gem "rails", "3.2.14"
    end

    appraise "rails-4" do
      gem "rails", "4.0.0"
    end

The dependencies in your `Appraisals` file are combined with dependencies in
your `Gemfile`, so you don't need to repeat anything that's the same for each
appraisal. If something is specified in both the Gemfile and an appraisal, the
version from the appraisal takes precedence.

### Examples of usage in the wild

Appraisal2 can be setup to achieve many different things, from testing against
different versions of services, like MySQL, Redis, or Memcached, and their drivers,
different versions of gems, different platforms, and running different types of validations
which each require a distinct set of gems.
It can also help developers to follow the [official recommendation](https://github.com/rubygems/bundler-site/pull/501) (since 2017) of the bundler team,
to commit the \[main\] `Gemfile.lock` for **both** apps **and** gems. It does this by giving you alternate gemfiles that won't have their `gemfiles/*.gemfile.lock` committed, so you can simply commit the main one without breaking CI.

Having so many different use cases means it can be helpful to others to see how you have done your implementation. If you are willing to spend the time documenting, please send a PR to update this table with another Appraisal2-using project, linking to the specific workflows people can check to see how it is done!

| # | gem                                                                           | locked / unlocked deps                                   | analysis / services                                                                                                                                                                                                                                            | SemVer / HEAD deps                                     | Rubies                                                                                                                                                                                                                | os |
|---|-------------------------------------------------------------------------------|----------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----|
| 1 | [omniauth-identity][1-gh]<br>[![Star][1-⭐️i]][1-gh]<br>[![Rank][1-🔢i]][1-🧰] | [![🔒️][1-🔒️i]][1-🔒️]<br>[![un🔒️][1-un🔒️i]][1-un🔒️] | [![Style][1-as⚙️i]][1-as⚙️]<br>[![Coverage][1-ac⚙️i]][1-ac⚙️]<br>[![Svcs][1-sc⚙️i]][1-sc⚙️]<br>[![L-Svcs][1-sl⚙️i]][1-sl⚙️]<br>[![S-Svcs][1-ss⚙️i]][1-ss⚙️]<br>[![U-Svcs][1-su⚙️i]][1-su⚙️]<br>[![A-Svcs][1-sa⚙️i]][1-sa⚙️]<br>[![J-Svcs][1-sj⚙️i]][1-sj⚙️]<br>[![AJ-Svcs][1-saj⚙️i]][1-saj⚙️] | [![Current][1-⏰i]][1-⏰]<br>[![Deps@HEAD][1-👟i]][1-👟] | [![Supported][1-👴i]][1-👴]<br>[![Unsupported][1-u👴i]][1-u👴]<br>[![Legacy][1-l👴i]][1-l👴]<br>[![Ancient][1-a👴i]][1-a👴]<br>[![JRuby][1-ji]][1-j]<br>[![JRuby Ancient][1-ja👴i]][1-ja👴]<br>[![Head][1-🗣️i]][1-🗣️] | ❌  |
| 2 | [rspec-stubbed_env][2-gh]<br>[![Star][2-⭐️i]][2-gh]<br>[![Rank][2-🔢i]][2-🧰] | [![🔒️][2-🔒️i]][2-🔒️]<br>[![un🔒️][2-un🔒️i]][2-un🔒️] | [![Style][2-as⚙️i]][2-as⚙️]<br>[![Coverage][2-ac⚙️i]][2-ac⚙️]                                                                                                                                                                                                  | [![Current][2-⏰i]][2-⏰]                                | [![Supported][2-👴i]][2-👴]<br>[![Unsupported][2-u👴i]][2-u👴]<br>[![Legacy][2-l👴i]][2-l👴]<br>[![Ancient][2-a👴i]][2-a👴]<br>[![JRuby][2-ji]][2-j]<br>[![Truffle][2-ti]][2-t]<br>[![Head][2-🗣️i]][2-🗣️]           | ❌  |
| 3 | [silent_stream][3-gh]<br>[![Star][3-⭐️i]][3-gh]<br>[![Rank][3-🔢i]][3-🧰]     | [![🔒️][3-🔒️i]][3-🔒️]<br>[![un🔒️][3-un🔒️i]][3-un🔒️] | [![Style][3-as⚙️i]][3-as⚙️]<br>[![Coverage][3-ac⚙️i]][3-ac⚙️]                                                                                                                                                                                                  | [![Current][3-⏰i]][3-⏰]                                | [![Supported][3-👴i]][3-👴]<br>[![Unsupported][3-u👴i]][3-u👴]<br>[![Legacy][3-l👴i]][3-l👴]<br>[![Ancient][3-a👴i]][3-a👴]<br>[![JRuby][3-ji]][3-j]<br>[![Truffle][3-ti]][3-t]<br>[![Head][3-🗣️i]][3-🗣️]           | ❌  |
| 4 | [oauth2][4-gh]<br>[![Star][4-⭐️i]][4-gh]<br>[![Rank][4-🔢i]][4-🧰]            | [![🔒️][4-🔒️i]][4-🔒️]<br>[![un🔒️][4-un🔒️i]][4-un🔒️] | [![Style][4-as⚙️i]][4-as⚙️]<br>[![Coverage][4-ac⚙️i]][4-ac⚙️]<br>[![Svcs][4-sc⚙️i]][4-sc⚙️]<br>[![L-Svcs][4-sl⚙️i]][4-sl⚙️]<br>[![S-Svcs][4-ss⚙️i]][4-ss⚙️]<br>[![U-Svcs][4-su⚙️i]][4-su⚙️]<br>[![A-Svcs][4-sa⚙️i]][4-sa⚙️]<br>[![J-Svcs][4-sj⚙️i]][4-sj⚙️]<br>[![AJ-Svcs][4-saj⚙️i]][4-saj⚙️] | [![Current][4-⏰i]][4-⏰]<br>[![Deps@HEAD][4-👟i]][4-👟] | [![Supported][4-👴i]][4-👴]<br>[![Unsupported][4-u👴i]][4-u👴]<br>[![Legacy][4-l👴i]][4-l👴]<br>[![Ancient][4-a👴i]][4-a👴]<br>[![JRuby][4-ji]][4-j]<br>[![JRuby Ancient][4-ja👴i]][4-ja👴]<br>[![Head][4-🗣️i]][4-🗣️] | ❌  |

[1-gh]: https://github.com/omniauth/omniauth-identity
[1-🧰]: https://www.ruby-toolbox.com/projects/omniauth-identity
[1-⭐️i]: https://img.shields.io/github/stars/omniauth/omniauth-identity
[1-🔢i]: https://img.shields.io/gem/rd/omniauth-identity.svg
[1-🔒️]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/deps_locked.yml
[1-🔒️i]: https://github.com/omniauth/omniauth-identity/actions/workflows/deps_locked.yml/badge.svg
[1-un🔒️]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/deps_unlocked.yml
[1-un🔒️i]: https://github.com/omniauth/omniauth-identity/actions/workflows/deps_unlocked.yml/badge.svg
[1-as⚙️]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/style.yml
[1-as⚙️i]: https://github.com/omniauth/omniauth-identity/actions/workflows/style.yml/badge.svg
[1-ac⚙️]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/coverage.yml
[1-ac⚙️i]: https://github.com/omniauth/omniauth-identity/actions/workflows/coverage.yml/badge.svg
[1-sc⚙️]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/current-svc-adapters.yml
[1-sc⚙️i]: https://github.com/omniauth/omniauth-identity/actions/workflows/current-svc-adapters.yml/badge.svg
[1-sl⚙️]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/legacy-svc-adapters.yml
[1-sl⚙️i]: https://github.com/omniauth/omniauth-identity/actions/workflows/legacy-svc-adapters.yml/badge.svg
[1-ss⚙️]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/supported-svc-adapters.yml
[1-ss⚙️i]: https://github.com/omniauth/omniauth-identity/actions/workflows/supported-svc-adapters.yml/badge.svg
[1-su⚙️]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/unsupported-svc-adapters.yml
[1-su⚙️i]: https://github.com/omniauth/omniauth-identity/actions/workflows/unsupported-svc-adapters.yml/badge.svg
[1-sa⚙️]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/ancient-svc-adapters.yml
[1-sa⚙️i]: https://github.com/omniauth/omniauth-identity/actions/workflows/ancient-svc-adapters.yml/badge.svg
[1-sj⚙️]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/jruby-svc-adapters.yml
[1-sj⚙️i]: https://github.com/omniauth/omniauth-identity/actions/workflows/jruby-svc-adapters.yml/badge.svg
[1-saj⚙️]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/jruby-ancient-svc-adapters.yml
[1-saj⚙️i]: https://github.com/omniauth/omniauth-identity/actions/workflows/jruby-ancient-svc-adapters.yml/badge.svg
[1-⏰]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/current.yml
[1-⏰i]: https://github.com/omniauth/omniauth-identity/actions/workflows/current.yml/badge.svg
[1-j]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/jruby.yml
[1-ji]: https://github.com/omniauth/omniauth-identity/actions/workflows/jruby.yml/badge.svg
[1-👟]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/current-runtime-heads.yml
[1-👟i]: https://github.com/omniauth/omniauth-identity/actions/workflows/current-runtime-heads.yml/badge.svg
[1-👴]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/supported.yml
[1-👴i]: https://github.com/omniauth/omniauth-identity/actions/workflows/supported.yml/badge.svg
[1-u👴]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/unsupported.yml
[1-u👴i]: https://github.com/omniauth/omniauth-identity/actions/workflows/unsupported.yml/badge.svg
[1-l👴]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/legacy.yml
[1-l👴i]: https://github.com/omniauth/omniauth-identity/actions/workflows/legacy.yml/badge.svg
[1-a👴]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/ancient.yml
[1-a👴i]: https://github.com/omniauth/omniauth-identity/actions/workflows/ancient.yml/badge.svg
[1-ja👴]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/jruby-ancient.yml
[1-ja👴i]: https://github.com/omniauth/omniauth-identity/actions/workflows/jruby-ancient.yml/badge.svg
[1-🗣️]: https://github.com/omniauth/omniauth-identity/blob/main/.github/workflows/heads.yml
[1-🗣️i]: https://github.com/omniauth/omniauth-identity/actions/workflows/heads.yml/badge.svg
[1-gh]: https://github.com/omniauth/omniauth-identity

[2-gh]: https://github.com/pboling/rspec-stubbed_env
[2-🧰]: https://www.ruby-toolbox.com/projects/rspec-stubbed_env
[2-⭐️i]: https://img.shields.io/github/stars/pboling/rspec-stubbed_env
[2-🔢i]: https://img.shields.io/gem/rd/rspec-stubbed_env.svg
[2-🔒️]: https://github.com/pboling/rspec-stubbed_env/blob/main/.github/workflows/deps_locked.yml
[2-🔒️i]: https://github.com/pboling/rspec-stubbed_env/actions/workflows/deps_locked.yml/badge.svg
[2-un🔒️]: https://github.com/pboling/rspec-stubbed_env/blob/main/.github/workflows/deps_unlocked.yml
[2-un🔒️i]: https://github.com/pboling/rspec-stubbed_env/actions/workflows/deps_unlocked.yml/badge.svg
[2-as⚙️]: https://github.com/pboling/rspec-stubbed_env/blob/main/.github/workflows/style.yml
[2-as⚙️i]: https://github.com/pboling/rspec-stubbed_env/actions/workflows/style.yml/badge.svg
[2-ac⚙️]: https://github.com/pboling/rspec-stubbed_env/blob/main/.github/workflows/coverage.yml
[2-ac⚙️i]: https://github.com/pboling/rspec-stubbed_env/actions/workflows/coverage.yml/badge.svg
[2-⏰]: https://github.com/pboling/rspec-stubbed_env/blob/main/.github/workflows/current.yml
[2-⏰i]: https://github.com/pboling/rspec-stubbed_env/actions/workflows/current.yml/badge.svg
[2-j]: https://github.com/pboling/rspec-stubbed_env/blob/main/.github/workflows/jruby.yml
[2-ji]: https://github.com/pboling/rspec-stubbed_env/actions/workflows/jruby.yml/badge.svg
[2-t]: https://github.com/pboling/rspec-stubbed_env/blob/main/.github/workflows/truffle.yml
[2-ti]: https://github.com/pboling/rspec-stubbed_env/actions/workflows/truffle.yml/badge.svg
[2-👴]: https://github.com/pboling/rspec-stubbed_env/blob/main/.github/workflows/supported.yml
[2-👴i]: https://github.com/pboling/rspec-stubbed_env/actions/workflows/supported.yml/badge.svg
[2-u👴]: https://github.com/pboling/rspec-stubbed_env/blob/main/.github/workflows/unsupported.yml
[2-u👴i]: https://github.com/pboling/rspec-stubbed_env/actions/workflows/unsupported.yml/badge.svg
[2-l👴]: https://github.com/pboling/rspec-stubbed_env/blob/main/.github/workflows/legacy.yml
[2-l👴i]: https://github.com/pboling/rspec-stubbed_env/actions/workflows/legacy.yml/badge.svg
[2-a👴]: https://github.com/pboling/rspec-stubbed_env/blob/main/.github/workflows/ancient.yml
[2-a👴i]: https://github.com/pboling/rspec-stubbed_env/actions/workflows/ancient.yml/badge.svg
[2-🗣️]: https://github.com/pboling/rspec-stubbed_env/blob/main/.github/workflows/heads.yml
[2-🗣️i]: https://github.com/pboling/rspec-stubbed_env/actions/workflows/heads.yml/badge.svg

[3-gh]: https://github.com/pboling/silent_stream
[3-🧰]: https://www.ruby-toolbox.com/projects/silent_stream
[3-⭐️i]: https://img.shields.io/github/stars/pboling/silent_stream
[3-🔢i]: https://img.shields.io/gem/rd/silent_stream.svg
[3-🔒️]: https://github.com/pboling/silent_stream/blob/master/.github/workflows/deps_locked.yml
[3-🔒️i]: https://github.com/pboling/silent_stream/actions/workflows/deps_locked.yml/badge.svg
[3-un🔒️]: https://github.com/pboling/silent_stream/blob/master/.github/workflows/deps_unlocked.yml
[3-un🔒️i]: https://github.com/pboling/silent_stream/actions/workflows/deps_unlocked.yml/badge.svg
[3-as⚙️]: https://github.com/pboling/silent_stream/blob/master/.github/workflows/style.yml
[3-as⚙️i]: https://github.com/pboling/silent_stream/actions/workflows/style.yml/badge.svg
[3-ac⚙️]: https://github.com/pboling/silent_stream/blob/master/.github/workflows/coverage.yml
[3-ac⚙️i]: https://github.com/pboling/silent_stream/actions/workflows/coverage.yml/badge.svg
[3-⏰]: https://github.com/pboling/silent_stream/blob/master/.github/workflows/current.yml
[3-⏰i]: https://github.com/pboling/silent_stream/actions/workflows/current.yml/badge.svg
[3-j]: https://github.com/pboling/silent_stream/blob/master/.github/workflows/jruby.yml
[3-ji]: https://github.com/pboling/silent_stream/actions/workflows/jruby.yml/badge.svg
[3-t]: https://github.com/pboling/silent_stream/blob/master/.github/workflows/truffle.yml
[3-ti]: https://github.com/pboling/silent_stream/actions/workflows/truffle.yml/badge.svg
[3-👴]: https://github.com/pboling/silent_stream/blob/master/.github/workflows/supported.yml
[3-👴i]: https://github.com/pboling/silent_stream/actions/workflows/supported.yml/badge.svg
[3-u👴]: https://github.com/pboling/silent_stream/blob/master/.github/workflows/unsupported.yml
[3-u👴i]: https://github.com/pboling/silent_stream/actions/workflows/unsupported.yml/badge.svg
[3-l👴]: https://github.com/pboling/silent_stream/blob/master/.github/workflows/legacy.yml
[3-l👴i]: https://github.com/pboling/silent_stream/actions/workflows/legacy.yml/badge.svg
[3-a👴]: https://github.com/pboling/silent_stream/blob/master/.github/workflows/ancient.yml
[3-a👴i]: https://github.com/pboling/silent_stream/actions/workflows/ancient.yml/badge.svg
[3-🗣️]: https://github.com/pboling/silent_stream/blob/master/.github/workflows/heads.yml
[3-🗣️i]: https://github.com/pboling/silent_stream/actions/workflows/heads.yml/badge.svg

[4-gh]: https://github.com/ruby-oauth/oauth2
[4-🧰]: https://www.ruby-toolbox.com/projects/oauth2
[4-⭐️i]: https://img.shields.io/github/stars/ruby-oauth/oauth2
[4-🔢i]: https://img.shields.io/gem/rd/oauth2.svg
[4-🔒️]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/deps_locked.yml
[4-🔒️i]: https://github.com/ruby-oauth/oauth2/actions/workflows/deps_locked.yml/badge.svg
[4-un🔒️]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/deps_unlocked.yml
[4-un🔒️i]: https://github.com/ruby-oauth/oauth2/actions/workflows/deps_unlocked.yml/badge.svg
[4-as⚙️]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/style.yml
[4-as⚙️i]: https://github.com/ruby-oauth/oauth2/actions/workflows/style.yml/badge.svg
[4-ac⚙️]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/coverage.yml
[4-ac⚙️i]: https://github.com/ruby-oauth/oauth2/actions/workflows/coverage.yml/badge.svg
[4-sc⚙️]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/current-svc-adapters.yml
[4-sc⚙️i]: https://github.com/ruby-oauth/oauth2/actions/workflows/current-svc-adapters.yml/badge.svg
[4-sl⚙️]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/legacy-svc-adapters.yml
[4-sl⚙️i]: https://github.com/ruby-oauth/oauth2/actions/workflows/legacy-svc-adapters.yml/badge.svg
[4-ss⚙️]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/supported-svc-adapters.yml
[4-ss⚙️i]: https://github.com/ruby-oauth/oauth2/actions/workflows/supported-svc-adapters.yml/badge.svg
[4-su⚙️]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/unsupported-svc-adapters.yml
[4-su⚙️i]: https://github.com/ruby-oauth/oauth2/actions/workflows/unsupported-svc-adapters.yml/badge.svg
[4-sa⚙️]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/ancient-svc-adapters.yml
[4-sa⚙️i]: https://github.com/ruby-oauth/oauth2/actions/workflows/ancient-svc-adapters.yml/badge.svg
[4-sj⚙️]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/jruby-svc-adapters.yml
[4-sj⚙️i]: https://github.com/ruby-oauth/oauth2/actions/workflows/jruby-svc-adapters.yml/badge.svg
[4-saj⚙️]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/jruby-ancient-svc-adapters.yml
[4-saj⚙️i]: https://github.com/ruby-oauth/oauth2/actions/workflows/jruby-ancient-svc-adapters.yml/badge.svg
[4-⏰]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/current.yml
[4-⏰i]: https://github.com/ruby-oauth/oauth2/actions/workflows/current.yml/badge.svg
[4-j]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/jruby.yml
[4-ji]: https://github.com/ruby-oauth/oauth2/actions/workflows/jruby.yml/badge.svg
[4-👟]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/current-runtime-heads.yml
[4-👟i]: https://github.com/ruby-oauth/oauth2/actions/workflows/current-runtime-heads.yml/badge.svg
[4-👴]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/supported.yml
[4-👴i]: https://github.com/ruby-oauth/oauth2/actions/workflows/supported.yml/badge.svg
[4-u👴]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/unsupported.yml
[4-u👴i]: https://github.com/ruby-oauth/oauth2/actions/workflows/unsupported.yml/badge.svg
[4-l👴]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/legacy.yml
[4-l👴i]: https://github.com/ruby-oauth/oauth2/actions/workflows/legacy.yml/badge.svg
[4-a👴]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/ancient.yml
[4-a👴i]: https://github.com/ruby-oauth/oauth2/actions/workflows/ancient.yml/badge.svg
[4-ja👴]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/jruby-ancient.yml
[4-ja👴i]: https://github.com/ruby-oauth/oauth2/actions/workflows/jruby-ancient.yml/badge.svg
[4-🗣️]: https://github.com/ruby-oauth/oauth2/blob/main/.github/workflows/heads.yml
[4-🗣️i]: https://github.com/ruby-oauth/oauth2/actions/workflows/heads.yml/badge.svg

## ⚒️ Basic Usage

Once you've configured the appraisals you want to use, you need to install the
dependencies for each appraisal:

    $ bundle exec appraisal install

This will resolve, install, and lock the dependencies for that appraisal using
bundler. Once you have your dependencies set up, you can run any command in a
single appraisal:

    $ bundle exec appraisal rails-3 rake test

This will run `rake test` using the dependencies configured for Rails 3. You can
also run each appraisal in turn:

    $ bundle exec appraisal rake test

If you want to use only the dependencies from your Gemfile, just run `rake
test` as normal. This allows you to keep running with the latest versions of
your dependencies in quick test runs, but keep running the tests in older
versions to check for regressions.

In the case that you want to run all the appraisals by default when you run
`rake`, you can override your default Rake task by putting this into your Rakefile:

    if !ENV["APPRAISAL_INITIALIZED"] && ENV.fetch("CI", "false").casecmp("false") == 0
      task :default => :appraisal
    end

(Appraisal2 sets `APPRAISAL_INITIALIZED` environment variable when it runs your
process. We put a check here to ensure that `appraisal rake` command should run
your real default task, which usually is your `test` task.)

Note that this may conflict with your CI setup if you decide to split the test
into multiple processes by Appraisal2 and you are using `rake` to run tests by
default.

### Commands

```bash
appraisal clean                  # Remove all generated gemfiles and lockfiles from gemfiles folder
appraisal generate               # Generate a gemfile for each appraisal
appraisal help [COMMAND]         # Describe available commands or one specific command
appraisal install                # Resolve and install dependencies for each appraisal
appraisal list                   # List the names of the defined appraisals
appraisal update [LIST_OF_GEMS]  # Remove all generated gemfiles and lockfiles, resolve, and install dependencies again
appraisal version                # Display the version and exit
```

### Command Options

The `install` and `update` commands support several options:

| Option | Description |
|--------|-------------|
| `--gem-manager`, `-g` | Gem manager to use: `bundler` (default) or `ore` |
| `--jobs`, `-j` | Install gems in parallel using the given number of workers |
| `--retry` | Retry network and git requests that have failed (default: 1) |
| `--without` | A space-separated list of groups to skip during installation |
| `--full-index` | Run bundle install with the full-index argument |
| `--path` | Install gems in the specified directory |

## 🦀 Using Ore (Alternative Gem Manager)

Appraisal2 supports [ORE](https://github.com/contriboss/ore-light) as an alternative to Bundler
for dependency resolution and installation. Ore is a fast gem manager written in Go that aims
to be a drop-in replacement for Bundler.

### Installing Ore

You can install ORE via:

```bash
# Install ORE Light (no Ruby required for download)
# Installs to ~/.local/bin by default (no sudo needed)
curl -fsSL https://raw.githubusercontent.com/contriboss/ore-light/master/scripts/install.sh | bash

# For system-wide installation to /usr/local/bin
curl -fsSL https://raw.githubusercontent.com/contriboss/ore-light/master/scripts/install.sh | bash -s -- --system
```

### Using Ore with Appraisal2

To use ORE instead of bundler, pass the `--gem-manager=ore` option:

```bash
# Install dependencies using ORE
bundle exec appraisal install --gem-manager=ore

# Update dependencies using ORE
bundle exec appraisal update --gem-manager=ore
```

You can also use the short form:

```bash
bundle exec appraisal install -g ore
```

### Ore-Specific Options

When using ORE, some options are translated to ORE's equivalents:

| Appraisal Option | Ore Equivalent | Notes                               |
|------------------|----------------|-------------------------------------|
| `--jobs=N` | `-workers=N` | Only used when N > 1                |
| `--path=DIR` | `-vendor=DIR` | Sets the gem installation directory |
| `--without=GROUPS` | `-without=GROUP1,GROUP2` | Groups are comma-separated in ORE   |
| `--retry` | *(ignored)* | ORE handles retries internally      |
| `--full-index` | *(ignored)* | Not applicable to ORE               |

### Example Workflow with ORE

```bash
# Generate appraisal gemfiles
bundle exec appraisal generate

# Install dependencies using ORE (faster than bundler)
bundle exec appraisal install --gem-manager=ore --jobs=4

# Run tests against all appraisals
bundle exec appraisal rspec

# Update a specific gem using ORE
bundle exec appraisal update rack --gem-manager=ore
```

### When to Use Ore

Ore can be particularly beneficial when:

- You have many appraisals and want faster installation
- You're in a CI environment where installation speed matters
- You want to take advantage of ORE's parallel resolution capabilities

Note that ORE must be installed separately and available in your PATH.
If you specify ORE and it is not available, appraisal2 will raise an error.

Under the hood
--------------

Running `appraisal install` generates a Gemfile for each appraisal by combining
your root Gemfile with the specific requirements for each appraisal. These are
stored in the `gemfiles` directory, and should be added to version control to
ensure that versions within constraints of the Gemfile are always used.

When you prefix a command with `appraisal`, the command is run with the
appropriate Gemfile for that appraisal, ensuring the correct dependencies
are used.

Sharing Modular Gemfiles between Appraisals
-------

_New in appraisal2_ (not possible in thoughtbot's appraisal)

It is common for Appraisals to duplicate sets of gems, and sometimes it
makes sense to DRY this up into a shared, modular, gemfile.
In a scenario where you do not load your main Gemfile in your Appraisals,
but you want to declare your various gem sets for e.g.
`%w(coverage test documentation audit)` once each, you can re-use the same
modular gemfiles for local development by referencing them from the main
Gemfile.

To do this, use the `eval_gemfile` declaration within the necessary
`appraise` block in your `Appraisals` file, which will behave the same as
`eval_gemfile` does in a normal Gemfile.

### Example Usage

You could put your modular gemfiles in the `gemfiles` directory, or nest
them in `gemfiles/modular/*`, which will be used for this example.

**Gemfile**
```ruby
eval_gemfile "gemfiles/modular/audit.gemfile"
```

**gemfiles/modular/audit.gemfile**
```ruby
# Many gems are dropping support for Ruby < 3.1,
#   so we only want to run our security audit in CI on Ruby 3.1+
gem "bundler-audit", "~> 0.9.2"
# And other security audit gems...
```

**Appraisals**
```ruby
appraise "ruby-2-7" do
  gem "dummy"
end

appraise "ruby-3-0" do
  gem "dummy"
end

appraise "ruby-3-1" do
  gem "dummy"
  eval_gemfile "modular/audit.gemfile"
end

appraise "ruby-3-2" do
  gem "dummy"
  eval_gemfile "modular/audit.gemfile"
end

appraise "ruby-3-3" do
  gem "dummy"
  eval_gemfile "modular/audit.gemfile"
end

appraise "ruby-3-4" do
  gem "dummy"
  eval_gemfile "modular/audit.gemfile"
end
```

**Appraisal2.root.gemfile**
```ruby
source "https://gem.coop"

# Appraisal2 Root Gemfile is for running appraisal to generate the Appraisal2 Gemfiles
# We do not load the standard Gemfile, as it is tailored for local development,
#   while appraisals are tailored for CI.

gemspec

gem "appraisal2"
```

Now when you need to update your appraisals:
```shell
BUNDLE_GEMFILE=Appraisal2.root.gemfile bundle exec appraisal update
```

### Removing Gems using Appraisal2

It is common while managing multiple Gemfiles for dependencies to become deprecated and no
longer necessary, meaning they need to be removed from the Gemfile for a specific `appraisal`.
To do this, use the `remove_gem` declaration within the necessary `appraise` block in your
`Appraisals` file.

#### Example Usage

**Gemfile**
```ruby
gem "rails", "~> 4.2"

group :test do
  gem "rspec", "~> 4.0"
  gem "test_after_commit"
end
```

**Appraisals**
```ruby
appraise "rails-5" do
  gem "rails", "~> 5.2"

  group :test do
    remove_gem "test_after_commit"
  end
end
```

Using the `Appraisals` file defined above, this is what the resulting `Gemfile` will look like:
```ruby
gem "rails", "~> 5.2"

group :test do
  gem "rspec", "~> 4.0"
end
```

### Customization

It is possible to customize the generated Gemfiles by adding a `customize_gemfiles` block to
your `Appraisals` file. The block must contain a hash of key/value pairs. Currently supported
customizations include:
- heading: a string that by default adds "# This file was generated by Appraisal2" to the top of each Gemfile, (the string will be commented for you)
- single_quotes: a boolean that controls if strings are single quoted in each Gemfile, defaults to false

You can also provide variables for substitution in the heading, based on each appraisal. Currently supported variables:
- `%{appraisal}`: Becomes the name of each appraisal, e.g. `rails-3`
- `%{gemfile}`: Becomes the filename of each gemfile, e.g. `rails-3.gemfile`
- `%{gemfile_path}`: Becomes the full path of each gemfile, e.g. `/path/to/project/gemfiles/rails-3.gemfile`
- `%{lockfile}`: Becomes the filename of each lockfile, e.g. `rails-3.gemfile.lock`
- `%{lockfile_path}`: Becomes the full path of each lockfile, e.g. `/path/to/project/gemfiles/rails-3.gemfile.lock`
- `%{relative_gemfile_path}`: Becomes the relative path of each gemfile, e.g. `gemfiles/rails-3.gemfile`
- `%{relative_lockfile_path}`: Becomes the relative path of each lockfile, e.g. `gemfiles/rails-3.gemfile.lock`

#### Example Usage

**Appraisals**
```ruby
customize_gemfiles do
  {
    :single_quotes => true,
    :heading => <<-HEADING,
frozen_string_literal: true

`%{gemfile}` has been generated by Appraisal2, do NOT modify it or `%{lockfile}` directly!
Make the changes to the "%{appraisal}" block in `Appraisals` instead. See the conventions at https://example.com/
    HEADING
  }
end

appraise "rails-3" do
  gem "rails", "3.2.14"
end
```

Using the `Appraisals` file defined above, this is what the resulting `Gemfile` will look like:
```ruby
# frozen_string_literal: true

# `rails-3.gemfile` has been generated by Appraisal2, do NOT modify it or `rails-3.gemfile.lock` directly!
# Make the changes to the "rails-3" block in `Appraisals` instead. See the conventions at https://example.com/

gem "rails", "3.2.14"
```

### Version Control

When using Appraisal2, we recommend you check in the Gemfiles that Appraisal2
generates within the gemfiles directory, but exclude the lockfiles there
(`*.gemfile.lock`). The Gemfiles are useful when running your tests against a
continuous integration server.

Additionally, the Bundler team [officially recommends](https://github.com/rubygems/bundler-site/pull/501)
committing the main `Gemfile.lock` for **both** gems **and** libraries.

### Circle CI Integration

In Circle CI you can override the default testing behavior.
You can configure Appraisal2 to execute your tests.

In order to this you can put the following configuration in your circle.yml file:

```yml
dependencies:
  post:
    - bundle exec appraisal install
test:
  pre:
    - bundle exec appraisal rake db:create
    - bundle exec appraisal rake db:migrate
  override:
    - bundle exec appraisal rspec
```

Notice that we are running an rspec suite. You can customize your testing
command in the `override` section and use your favourite one.

## 🔐 Security

See [SECURITY.md][🔐security].

## 🤝 Contributing

If you need some ideas of where to help, you could work on adding more code coverage,
or if it is already 💯 (see [below](#code-coverage)) check [issues][🤝gh-issues], or [PRs][🤝gh-pulls],
or use the gem and think about how it could be better.

We [![Keep A Changelog][📗keep-changelog-img]][📗keep-changelog] so if you make changes, remember to update it.

See [CONTRIBUTING.md][🤝contributing] for more detailed instructions.

### 🚀 Release Instructions

See [CONTRIBUTING.md][🤝contributing].

### Code Coverage

[![Coveralls Test Coverage][🔑coveralls-img]][🔑coveralls]

[![QLTY Test Coverage][🔑qlty-covi]][🔑qlty-cov]

### 🪇 Code of Conduct

Everyone interacting with this project's codebases, issue trackers,
chat rooms and mailing lists agrees to follow the [![Contributor Covenant 2.1][🪇conduct-img]][🪇conduct].

## 🌈 Contributors

[![Contributors][🖐contributors-img]][🖐contributors]

Made with [contributors-img][🖐contrib-rocks].

## ⭐️ Star History

<a href="https://star-history.com/#appraisal-rb/appraisal2&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=appraisal-rb/appraisal2&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=appraisal-rb/appraisal2&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=appraisal-rb/appraisal2&type=Date" />
 </picture>
</a>

## 📌 Versioning

This Library adheres to [![Semantic Versioning 2.0.0][📌semver-img]][📌semver].
Violations of this scheme should be reported as bugs.
Specifically, if a minor or patch version is released that breaks backward compatibility,
a new version should be immediately released that restores compatibility.
Breaking changes to the public API will only be introduced with new major versions.

### 📌 Is "Platform Support" part of the public API?

Yes.  But I'm obligated to include notes...

SemVer should, but doesn't explicitly, say that dropping support for specific Platforms
is a *breaking change* to an API.
It is obvious to many, but not all, and since the spec is silent, the bike shedding is endless.

> dropping support for a platform is both obviously and objectively a breaking change

- Jordan Harband (@ljharb, maintainer of SemVer) [in SemVer issue 716][📌semver-breaking]

To get a better understanding of how SemVer is intended to work over a project's lifetime,
read this article from the creator of SemVer:

- ["Major Version Numbers are Not Sacred"][📌major-versions-not-sacred]

As a result of this policy, and the interpretive lens used by the maintainer,
you can (and should) specify a dependency on these libraries using
the [Pessimistic Version Constraint][📌pvc] with two digits of precision.

For example:

```ruby
spec.add_dependency("appraisal2", "~> 3.0")
```

See [CHANGELOG.md][📌changelog] for a list of releases.

## 📄 License

The gem is available as open source under the terms of
the [MIT License][📄license] [![License: MIT][📄license-img]][📄license-ref].
See [LICENSE.txt][📄license] for the official [Copyright Notice][📄copyright-notice-explainer].

### © Copyright

<ul>
    <li>
        Copyright (c) 2024-2025 Peter H. Boling, of
        <a href="https://discord.gg/3qme4XHNKN">
            Galtzo.com
            <picture>
              <img src="https://logos.galtzo.com/assets/images/galtzo-floss/avatar-128px-blank.svg" alt="Galtzo.com Logo (wordless) by Aboling0, CC BY-SA 4.0" width="24">
            </picture>
        </a>, and Appraisal2 contributors
    </li>
    <li>Copyright (c) 2010-2013 Joe Ferris and thoughtbot, inc.</li>
</ul>

## 🤑 One more thing

Having arrived at the bottom of the page, please endure a final supplication.
The primary maintainer of this gem, Peter Boling, wants
Ruby to be a great place for people to solve problems, big and small.
Please consider supporting his efforts via the giant yellow link below,
or one of the smaller ones, depending on button size preference.

[![Buy me a latte][🖇buyme-img]][🖇buyme]

[![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Donate on Polar][🖇polar-img]][🖇polar] [![Donate to my FLOSS or refugee efforts at ko-fi.com][🖇kofi-img]][🖇kofi] [![Donate to my FLOSS or refugee efforts using Patreon][🖇patreon-img]][🖇patreon]

P.S. If you need help️ or want to say thanks, 👇 Join the Discord.

[![Live Chat on Discord][✉️discord-invite-img]][✉️discord-invite]

[⛳liberapay-img]: https://img.shields.io/liberapay/goal/pboling.svg?logo=liberapay
[⛳liberapay]: https://liberapay.com/pboling/donate
[🖇sponsor-img]: https://img.shields.io/badge/Sponsor_Me!-pboling.svg?style=social&logo=github
[🖇sponsor]: https://github.com/sponsors/pboling
[🖇polar-img]: https://img.shields.io/badge/polar-donate-yellow.svg
[🖇polar]: https://polar.sh/pboling
[🖇kofi-img]: https://img.shields.io/badge/a_more_different_coffee-✓-yellow.svg
[🖇kofi]: https://ko-fi.com/O5O86SNP4
[🖇patreon-img]: https://img.shields.io/badge/patreon-donate-yellow.svg
[🖇patreon]: https://patreon.com/galtzo
[🖇buyme-small-img]: https://img.shields.io/badge/buy_me_a_coffee-✓-yellow.svg?style=flat
[🖇buyme-img]: https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20latte&emoji=&slug=pboling&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff
[🖇buyme]: https://www.buymeacoffee.com/pboling
[✉️discord-invite]: https://discord.gg/3qme4XHNKN
[✉️discord-invite-img]: https://img.shields.io/discord/1373797679469170758?style=for-the-badge

[✇bundle-group-pattern]: https://gist.github.com/pboling/4564780
[⛳️gem-namespace]: https://github.com/appraisal-rb/appraisal2
[⛳️namespace-img]: https://img.shields.io/badge/namespace-Appraisal-brightgreen.svg?style=flat&logo=ruby&logoColor=white
[⛳️gem-name]: https://rubygems.org/gems/appraisal2
[⛳️name-img]: https://img.shields.io/badge/name-appraisal2-brightgreen.svg?style=flat&logo=rubygems&logoColor=red
[🚂bdfl-blog]: http://www.railsbling.com/tags/appraisal2
[🚂bdfl-blog-img]: https://img.shields.io/badge/blog-railsbling-0093D0.svg?style=for-the-badge&logo=rubyonrails&logoColor=orange
[🚂bdfl-contact]: http://www.railsbling.com/contact
[🚂bdfl-contact-img]: https://img.shields.io/badge/Contact-BDFL-0093D0.svg?style=flat&logo=rubyonrails&logoColor=red
[💖🖇linkedin]: http://www.linkedin.com/in/peterboling
[💖🖇linkedin-img]: https://img.shields.io/badge/PeterBoling-LinkedIn-0B66C2?style=flat&logo=newjapanprowrestling
[💖✌️wellfound]: https://angel.co/u/peter-boling
[💖✌️wellfound-img]: https://img.shields.io/badge/peter--boling-orange?style=flat&logo=wellfound
[💖💲crunchbase]: https://www.crunchbase.com/person/peter-boling
[💖💲crunchbase-img]: https://img.shields.io/badge/peter--boling-purple?style=flat&logo=crunchbase
[💖🐘ruby-mast]: https://ruby.social/@galtzo
[💖🐘ruby-mast-img]: https://img.shields.io/mastodon/follow/109447111526622197?domain=https%3A%2F%2Fruby.social&style=flat&logo=mastodon&label=Ruby%20%40galtzo
[💖🦋bluesky]: https://bsky.app/profile/galtzo.com
[💖🦋bluesky-img]: https://img.shields.io/badge/@galtzo.com-0285FF?style=flat&logo=bluesky&logoColor=white
[💖🌳linktree]: https://linktr.ee/galtzo
[💖🌳linktree-img]: https://img.shields.io/badge/galtzo-purple?style=flat&logo=linktree
[💖💁🏼‍♂️devto]: https://dev.to/galtzo
[💖💁🏼‍♂️devto-img]: https://img.shields.io/badge/dev.to-0A0A0A?style=flat&logo=devdotto&logoColor=white
[💖💁🏼‍♂️aboutme]: https://about.me/peter.boling
[💖💁🏼‍♂️aboutme-img]: https://img.shields.io/badge/about.me-0A0A0A?style=flat&logo=aboutme&logoColor=white
[💖🧊berg]: https://codeberg.org/pboling
[💖🐙hub]: https://github.org/pboling
[💖🛖hut]: https://sr.ht/~galtzo/
[💖🧪lab]: https://gitlab.com/pboling
[👨🏼‍🏫expsup-upwork]: https://www.upwork.com/freelancers/~014942e9b056abdf86?mp_source=share
[👨🏼‍🏫expsup-upwork-img]: https://img.shields.io/badge/UpWork-13544E?style=for-the-badge&logo=Upwork&logoColor=white
[👨🏼‍🏫expsup-codementor]: https://www.codementor.io/peterboling?utm_source=github&utm_medium=button&utm_term=peterboling&utm_campaign=github
[👨🏼‍🏫expsup-codementor-img]: https://img.shields.io/badge/CodeMentor-Get_Help-1abc9c?style=for-the-badge&logo=CodeMentor&logoColor=white
[🏙️entsup-tidelift]: https://tidelift.com/subscription
[🏙️entsup-tidelift-img]: https://img.shields.io/badge/Tidelift_and_Sonar-Enterprise_Support-FD3456?style=for-the-badge&logo=sonar&logoColor=white
[🏙️entsup-tidelift-sonar]: https://blog.tidelift.com/tidelift-joins-sonar
[💁🏼‍♂️peterboling]: http://www.peterboling.com
[🚂railsbling]: http://www.railsbling.com
[📜src-gl-img]: https://img.shields.io/badge/GitLab-FBA326?style=for-the-badge&logo=Gitlab&logoColor=orange
[📜src-gl]: https://gitlab.com/appraisal-rb/appraisal2/
[📜src-cb-img]: https://img.shields.io/badge/CodeBerg-4893CC?style=for-the-badge&logo=CodeBerg&logoColor=blue
[📜src-cb]: https://codeberg.org/appraisal-rb/appraisal2
[📜src-gh-img]: https://img.shields.io/badge/GitHub-238636?style=for-the-badge&logo=Github&logoColor=green
[📜src-gh]: https://github.com/appraisal-rb/appraisal2
[📜docs-cr-rd-img]: https://img.shields.io/badge/RubyDoc-Current_Release-943CD2?style=for-the-badge&logo=readthedocs&logoColor=white
[📜docs-head-rd-img]: https://img.shields.io/badge/YARD_on_Galtzo.com-HEAD-943CD2?style=for-the-badge&logo=readthedocs&logoColor=white
[📜wiki]: https://gitlab.com/appraisal-rb/appraisal2/-/wikis/home
[📜wiki-img]: https://img.shields.io/badge/wiki-examples-943CD2.svg?style=for-the-badge&logo=Wiki&logoColor=white
[👽dl-rank]: https://rubygems.org/gems/appraisal2
[👽dl-ranki]: https://img.shields.io/gem/rd/appraisal2.svg
[👽oss-help]: https://www.codetriage.com/appraisal-rb/appraisal2
[👽oss-helpi]: https://www.codetriage.com/appraisal-rb/appraisal2/badges/users.svg
[👽version]: https://rubygems.org/gems/appraisal2
[👽versioni]: https://img.shields.io/gem/v/appraisal2.svg
[🔑qlty-mnt]: https://qlty.sh/gh/appraisal-rb/projects/appraisal2
[🔑qlty-mnti]: https://qlty.sh/gh/appraisal-rb/projects/appraisal2/maintainability.svg
[🔑qlty-cov]: https://qlty.sh/gh/appraisal-rb/projects/appraisal2/metrics/code?sort=coverageRating
[🔑qlty-covi]: https://qlty.sh/gh/appraisal-rb/projects/appraisal2/coverage.svg
[🔑codecov]: https://codecov.io/gh/appraisal-rb/appraisal2
[🔑codecovi♻️]: https://codecov.io/gh/appraisal-rb/appraisal2/branch/main/graph/badge.svg?token=0X5VEW9USD
[🔑coveralls]: https://coveralls.io/github/appraisal-rb/appraisal2?branch=main
[🔑coveralls-img]: https://coveralls.io/repos/github/appraisal-rb/appraisal2/badge.svg?branch=main
[🔑depfu]: https://depfu.com/github/appraisal-rb/appraisal2?project_id=67033
[🔑depfui♻️]: https://badges.depfu.com/badges/b5344eec8b60c9e72bd9145ff53cd07b/count.svg
[🖐codeQL]: https://github.com/appraisal-rb/appraisal2/security/code-scanning
[🖐codeQL-img]: https://github.com/appraisal-rb/appraisal2/actions/workflows/codeql-analysis.yml/badge.svg
[🚎1-r2.3-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-2-3.yml
[🚎1-r2.3-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-2-3.yml/badge.svg
[🚎1-r2.4-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-2-4.yml
[🚎1-r2.4-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-2-4.yml/badge.svg
[🚎1-r2.5-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-2-5.yml
[🚎1-r2.5-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-2-5.yml/badge.svg
[🚎1-r2.6-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-2-6.yml
[🚎1-r2.6-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-2-6.yml/badge.svg
[🚎1-r2.7-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-2-7.yml
[🚎1-r2.7-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-2-7.yml/badge.svg
[🚎2-cov-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/coverage.yml
[🚎2-cov-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/coverage.yml/badge.svg
[🚎3-hd-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/heads.yml
[🚎3-hd-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/heads.yml/badge.svg
[🚎4-r3.0-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-3-0.yml
[🚎4-r3.0-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-3-0.yml/badge.svg
[🚎4-r3.1-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-3-1.yml
[🚎4-r3.1-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-3-1.yml/badge.svg
[🚎4-r3.2-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-3-2.yml
[🚎4-r3.2-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-3-2.yml/badge.svg
[🚎4-r3.3-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-3-3.yml
[🚎4-r3.3-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-3-3.yml/badge.svg
[🚎5-st-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/style.yml
[🚎5-st-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/style.yml/badge.svg
[🚎10-j9.4-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/jruby-9-4.yml
[🚎10-j9.4-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/jruby-9-4.yml/badge.svg
[🚎11-c-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/current.yml
[🚎11-c-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/current.yml/badge.svg
[🚎12-crh-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/current-runtime-heads.yml
[🚎12-crh-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/current-runtime-heads.yml/badge.svg
[🚎13-🔒️-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/deps_locked.yml
[🚎13-🔒️-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/deps_locked.yml/badge.svg
[🚎14-🔓️-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/deps_unlocked.yml
[🚎14-🔓️-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/deps_unlocked.yml/badge.svg
[💎ruby-2.3i]: https://img.shields.io/badge/Ruby-2.3-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.4i]: https://img.shields.io/badge/Ruby-2.4-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.5i]: https://img.shields.io/badge/Ruby-2.5-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.6i]: https://img.shields.io/badge/Ruby-2.6-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.7i]: https://img.shields.io/badge/Ruby-2.7-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.0i]: https://img.shields.io/badge/Ruby-3.0-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.1i]: https://img.shields.io/badge/Ruby-3.1-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.2i]: https://img.shields.io/badge/Ruby-3.2-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.3i]: https://img.shields.io/badge/Ruby-3.3-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-c-i]: https://img.shields.io/badge/Ruby-current-CC342D?style=for-the-badge&logo=ruby&logoColor=green
[💎ruby-headi]: https://img.shields.io/badge/Ruby-HEAD-CC342D?style=for-the-badge&logo=ruby&logoColor=blue
[💎truby-c-i]: https://img.shields.io/badge/Truffle_Ruby-current-34BCB1?style=for-the-badge&logo=ruby&logoColor=green
[💎truby-headi]: https://img.shields.io/badge/Truffle_Ruby-HEAD-34BCB1?style=for-the-badge&logo=ruby&logoColor=blue
[💎jruby-9.4i]: https://img.shields.io/badge/JRuby-9.4-FBE742?style=for-the-badge&logo=ruby&logoColor=red
[💎jruby-c-i]: https://img.shields.io/badge/JRuby-current-FBE742?style=for-the-badge&logo=ruby&logoColor=green
[💎jruby-headi]: https://img.shields.io/badge/JRuby-HEAD-FBE742?style=for-the-badge&logo=ruby&logoColor=blue
[🤝gh-issues]: https://github.com/appraisal-rb/appraisal2/issues
[🤝gh-pulls]: https://github.com/appraisal-rb/appraisal2/pulls
[🤝gl-issues]: https://gitlab.com/appraisal-rb/appraisal2/-/issues
[🤝gl-pulls]: https://gitlab.com/appraisal-rb/appraisal2/-/merge_requests
[🤝cb-issues]: https://codeberg.org/appraisal-rb/appraisal2/issues
[🤝cb-pulls]: https://codeberg.org/appraisal-rb/appraisal2/pulls
[🤝cb-donate]: https://donate.codeberg.org/
[🤝contributing]: CONTRIBUTING.md
[🔑codecov-g♻️]: https://codecov.io/gh/appraisal-rb/appraisal2/graphs/tree.svg?token=0X5VEW9USD
[🖐contrib-rocks]: https://contrib.rocks
[🖐contributors]: https://github.com/appraisal-rb/appraisal2/graphs/contributors
[🖐contributors-img]: https://contrib.rocks/image?repo=appraisal-rb/appraisal2
[🚎contributors-gl]: https://gitlab.com/appraisal-rb/appraisal2/-/graphs/main
[🪇conduct]: CODE_OF_CONDUCT.md
[🪇conduct-img]: https://img.shields.io/badge/Contributor_Covenant-2.1-259D6C.svg
[📌pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
[📌semver]: https://semver.org/spec/v2.0.0.html
[📌semver-img]: https://img.shields.io/badge/semver-2.0.0-259D6C.svg?style=flat
[📌semver-breaking]: https://github.com/semver/semver/issues/716#issuecomment-869336139
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[📌changelog]: CHANGELOG.md
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-34495e.svg?style=flat
[📌gitmoji]:https://gitmoji.dev
[📌gitmoji-img]:https://img.shields.io/badge/gitmoji_commits-%20😜%20😍-34495e.svg?style=flat-square
[🧮kloc]: https://www.youtube.com/watch?v=dQw4w9WgXcQ
[🧮kloc-img]: https://img.shields.io/badge/KLOC-1.186-FFDD67.svg?style=for-the-badge&logo=YouTube&logoColor=blue
[🔐security]: SECURITY.md
[🔐security-img]: https://img.shields.io/badge/security-policy-259D6C.svg?style=flat
[📄copyright-notice-explainer]: https://opensource.stackexchange.com/questions/5778/why-do-licenses-such-as-the-mit-license-specify-a-single-year
[📄license]: LICENSE.txt
[📄license-ref]: https://opensource.org/licenses/MIT
[📄license-img]: https://img.shields.io/badge/License-MIT-259D6C.svg
[📄ilo-declaration]: https://www.ilo.org/declaration/lang--en/index.htm
[📄ilo-declaration-img]: https://img.shields.io/badge/ILO_Fundamental_Principles-✓-259D6C.svg?style=flat
[🚎yard-current]: http://rubydoc.info/gems/appraisal2
[🚎yard-head]: https://appraisal2.galtzo.com
[💎stone_checksums]: https://github.com/pboling/stone_checksums
[💎SHA_checksums]: https://gitlab.com/appraisal-rb/appraisal2/-/tree/main/checksums
[💎rlts]: https://github.com/rubocop-lts/rubocop-lts
[💎rlts-img]: https://img.shields.io/badge/code_style_%26_linting-rubocop--lts-34495e.svg?plastic&logo=ruby&logoColor=white
[💎d-in-dvcs]: https://railsbling.com/posts/dvcs/put_the_d_in_dvcs/

<details>
  <summary>
    Disabled Badges
  </summary>

Badges for failing services.
Bug reports filed.
Once fixed, these should look much nicer.

[![CodeCov Test Coverage][🔑codecovi♻️]][🔑codecov]
[![Coverage Graph][🔑codecov-g♻️]][🔑codecov]

</details>
