<a href="https://github.com/appraisal-rb"><img alt="appraisal-rb Logo by Aboling0, CC BY-SA 4.0" src="https://logos.galtzo.com/assets/images/appraisal-rb/avatar-128px.svg" width="14%" align="right"/></a>

# 🔍️ Appraisal2

[![Version][👽versioni]][👽version] [![GitHub tag (latest SemVer)][⛳️tag-img]][⛳️tag] [![License: MIT][📄license-img]][📄license] [![Downloads Rank][👽dl-ranki]][👽dl-rank] [![CodeCov Test Coverage][🏀codecovi]][🏀codecov] [![Coveralls Test Coverage][🏀coveralls-img]][🏀coveralls] [![QLTY Test Coverage][🏀qlty-covi]][🏀qlty-cov] [![QLTY Maintainability][🏀qlty-mnti]][🏀qlty-mnt] [![CI Heads][🚎3-hd-wfi]][🚎3-hd-wf] [![CI Runtime Dependencies @ HEAD][🚎12-crh-wfi]][🚎12-crh-wf] [![CI Current][🚎11-c-wfi]][🚎11-c-wf] [![CI Truffle Ruby][🚎9-t-wfi]][🚎9-t-wf] [![CI JRuby][🚎10-j-wfi]][🚎10-j-wf] [![Deps Locked][🚎13-🔒️-wfi]][🚎13-🔒️-wf] [![Deps Unlocked][🚎14-🔓️-wfi]][🚎14-🔓️-wf] [![CI Test Coverage][🚎2-cov-wfi]][🚎2-cov-wf] [![CI Style][🚎5-st-wfi]][🚎5-st-wf] [![Apache SkyWalking Eyes License Compatibility Check][🚎15-🪪-wfi]][🚎15-🪪-wf]

`if ci_badges.map(&:color).detect { it != "green"}` ☝️ [let me know][✉️discord-invite], as I may have missed the [discord notification][✉️discord-invite].

---

`if ci_badges.map(&:color).all? { it == "green"}` 👇️ send money so I can do more of this. FLOSS maintenance is now my full-time job.

[![OpenCollective Backers][🖇osc-backers-i]][🖇osc-backers] [![OpenCollective Sponsors][🖇osc-sponsors-i]][🖇osc-sponsors] [![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Donate on PayPal][🖇paypal-img]][🖇paypal] [![Buy me a coffee][🖇buyme-small-img]][🖇buyme] [![Donate on Polar][🖇polar-img]][🖇polar] [![Donate at ko-fi.com][🖇kofi-img]][🖇kofi]

<details>
 <summary>👣 How will this project approach the September 2025 hostile takeover of RubyGems? 🚑️</summary>

I've summarized my thoughts in [this blog post](https://dev.to/galtzo/hostile-takeover-of-rubygems-my-thoughts-5hlo).

</details>

## 🌻 Synopsis <a href="https://discord.gg/3qme4XHNKN"><img alt="Galtzo FLOSS Logo by Aboling0, CC BY-SA 4.0" src="https://logos.galtzo.com/assets/images/galtzo-floss/avatar-128px.svg" width="8%" align="right"/></a> <a href="https://ruby-toolbox.com"><img alt="ruby-lang Logo, Yukihiro Matsumoto, Ruby Visual Identity Team, CC BY-SA 2.5" src="https://logos.galtzo.com/assets/images/ruby-lang/avatar-128px.svg" width="8%" align="right"/></a>

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
- support for caching gems across appraisals in CI workflows by setting `BUNDLE_PATH` in env
- support for [ORE](https://github.com/contriboss/ore-light) as an alternative gem manager (faster than bundler!)
  - For easy setup in **Gitea** [Actions](https://docs.gitea.com/usage/actions/overview), **Forgejo** [Actions](https://forgejo.org/docs/next/admin/actions/), **Codeberg** [Actions](https://docs.codeberg.org/ci/actions/), or **GitHub** [Actions](https://github.com/marketplace/actions/setup-ruby-with-rv-and-ore) check out [appraisal-rb/setup-ruby-flash](https://github.com/appraisal-rb/setup-ruby-flash)
- support for Ruby 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6 (all removed, or planned-to-be, in thoughtbot's `appraisal`)
  - NOTE: The [setup-ruby GH Action](https://github.com/ruby/setup-ruby) only ships support for Ruby 2.3+, so older Rubies are no longer tested in CI. Compatibility is assumed thanks to [![Enforced Code Style Linter][💎rlts-img]][💎rlts] enforcing the syntax for the oldest supported Ruby, which is Ruby v1.8. File a bug if you find something broken.
- Support for JRuby 9.4+
- Support for Truffle Ruby 22.3+
- Support for MRI Ruby 4+
- updated and improved documentation
- many other fixes and improvements. See [CHANGELOG](CHANGELOG.md) for details.

## 💡 Info you can shake a stick at

| Tokens to Remember | [![Gem name][⛳️name-img]][⛳️gem-name] [![Gem namespace][⛳️namespace-img]][⛳️gem-namespace] |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Works with JRuby | [![JRuby 9.2 Compat][💎jruby-9.2i]][🚎jruby-9.2-wf] [![JRuby 9.3 Compat][💎jruby-9.3i]][🚎jruby-9.3-wf] <br/> [![JRuby 9.4 Compat][💎jruby-9.4i]][🚎jruby-9.4-wf] [![JRuby current Compat][💎jruby-c-i]][🚎10-j-wf] [![JRuby HEAD Compat][💎jruby-headi]][🚎3-hd-wf]|
| Works with Truffle Ruby | [![Truffle Ruby 22.3 Compat][💎truby-22.3i]][🚎truby-22.3-wf] [![Truffle Ruby 23.0 Compat][💎truby-23.0i]][🚎truby-23.0-wf] [![Truffle Ruby 23.1 Compat][💎truby-23.1i]][🚎truby-23.1-wf] <br/> [![Truffle Ruby 24.2 Compat][💎truby-24.2i]][🚎truby-24.2-wf] [![Truffle Ruby 25.0 Compat][💎truby-25.0i]][🚎truby-25.0-wf] [![Truffle Ruby current Compat][💎truby-c-i]][🚎9-t-wf]|
| Works with MRI Ruby 4 | [![Ruby 4.0 Compat][💎ruby-4.0i]][🚎11-c-wf] [![Ruby current Compat][💎ruby-c-i]][🚎11-c-wf] [![Ruby HEAD Compat][💎ruby-headi]][🚎3-hd-wf]|
| Works with MRI Ruby 3 | [![Ruby 3.0 Compat][💎ruby-3.0i]][🚎ruby-3.0-wf] [![Ruby 3.1 Compat][💎ruby-3.1i]][🚎ruby-3.1-wf] [![Ruby 3.2 Compat][💎ruby-3.2i]][🚎ruby-3.2-wf] [![Ruby 3.3 Compat][💎ruby-3.3i]][🚎ruby-3.3-wf] [![Ruby 3.4 Compat][💎ruby-3.4i]][🚎ruby-3.4-wf]|
| Works with MRI Ruby 2 | ![Ruby 2.0 Compat][💎ruby-2.0i] ![Ruby 2.1 Compat][💎ruby-2.1i] ![Ruby 2.2 Compat][💎ruby-2.2i] <br/> [![Ruby 2.4 Compat][💎ruby-2.4i]][🚎ruby-2.4-wf] [![Ruby 2.5 Compat][💎ruby-2.5i]][🚎ruby-2.5-wf] [![Ruby 2.6 Compat][💎ruby-2.6i]][🚎ruby-2.6-wf] [![Ruby 2.7 Compat][💎ruby-2.7i]][🚎ruby-2.7-wf]|
| Works with MRI Ruby 1 | ![Ruby 1.9 Compat][💎ruby-1.9i]|
| Support & Community | [![Join Me on Daily.dev's RubyFriends][✉️ruby-friends-img]][✉️ruby-friends] [![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite] [![Get help from me on Upwork][👨🏼‍🏫expsup-upwork-img]][👨🏼‍🏫expsup-upwork] [![Get help from me on Codementor][👨🏼‍🏫expsup-codementor-img]][👨🏼‍🏫expsup-codementor] |
| Source | [![Source on GitLab.com][📜src-gl-img]][📜src-gl] [![Source on CodeBerg.org][📜src-cb-img]][📜src-cb] [![Source on Github.com][📜src-gh-img]][📜src-gh] [![The best SHA: dQw4w9WgXcQ!][🧮kloc-img]][🧮kloc] |
| Documentation | [![Current release on RubyDoc.info][📜docs-cr-rd-img]][🚎yard-current] [![YARD on Galtzo.com][📜docs-head-rd-img]][🚎yard-head] [![Maintainer Blog][🚂maint-blog-img]][🚂maint-blog] [![GitLab Wiki][📜gl-wiki-img]][📜gl-wiki] [![GitHub Wiki][📜gh-wiki-img]][📜gh-wiki] |
| Compliance | [![License: MIT][📄license-img]][📄license] [![Apache license compatibility: Category A][📄license-compat-img]][📄license-compat] [![📄ilo-declaration-img]][📄ilo-declaration] [![Security Policy][🔐security-img]][🔐security] [![Contributor Covenant 2.1][🪇conduct-img]][🪇conduct] [![SemVer 2.0.0][📌semver-img]][📌semver] |
| Style | [![Enforced Code Style Linter][💎rlts-img]][💎rlts] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog] [![Gitmoji Commits][📌gitmoji-img]][📌gitmoji] [![Compatibility appraised by: appraisal2][💎appraisal2-img]][💎appraisal2] |
| Maintainer 🎖️ | [![Follow Me on LinkedIn][💖🖇linkedin-img]][💖🖇linkedin] [![Follow Me on Ruby.Social][💖🐘ruby-mast-img]][💖🐘ruby-mast] [![Follow Me on Bluesky][💖🦋bluesky-img]][💖🦋bluesky] [![Contact Maintainer][🚂maint-contact-img]][🚂maint-contact] [![My technical writing][💖💁🏼‍♂️devto-img]][💖💁🏼‍♂️devto] |
| `...` 💖 | [![Find Me on WellFound:][💖✌️wellfound-img]][💖✌️wellfound] [![Find Me on CrunchBase][💖💲crunchbase-img]][💖💲crunchbase] [![My LinkTree][💖🌳linktree-img]][💖🌳linktree] [![More About Me][💖💁🏼‍♂️aboutme-img]][💖💁🏼‍♂️aboutme] [🧊][💖🧊berg] [🐙][💖🐙hub] [🛖][💖🛖hut] [🧪][💖🧪lab] |

### Compatibility

Compatible with MRI Ruby 1.8.7+, and concordant releases of JRuby, and TruffleRuby.
CI workflows and Appraisals are generated for MRI Ruby 2.4+.
This test floor is configured by `ruby.test_minimum` in `.kettle-jem.yml` and
may be higher than the gem's runtime compatibility floor when legacy Rubies are
not practical for the current toolchain.

| 🚚 _Amazing_ test matrix was brought to you by | 🔎 appraisal2 🔎 and the color 💚 green 💚 |
|------------------------------------------------|--------------------------------------------------------|
| 👟 Check it out! | ✨ [github.com/appraisal-rb/appraisal2][💎appraisal2] ✨ |

### Federated DVCS

<details markdown="1">
 <summary>Find this repo on federated forges (Coming soon!)</summary>

| Federated [DVCS][💎d-in-dvcs] Repository | Status | Issues | PRs | Wiki | CI | Discussions |
|-------------------------------------------------|-----------------------------------------------------------------------|---------------------------|--------------------------|---------------------------|--------------------------|------------------------------|
| 🧪 [appraisal-rb/appraisal2 on GitLab][📜src-gl] | The Truth | [💚][🤝gl-issues] | [💚][🤝gl-pulls] | [💚][📜gl-wiki] | 🐭 Tiny Matrix | ➖ |
| 🧊 [appraisal-rb/appraisal2 on CodeBerg][📜src-cb] | An Ethical Mirror ([Donate][🤝cb-donate]) | [💚][🤝cb-issues] | [💚][🤝cb-pulls] | ➖ | ⭕️ No Matrix | ➖ |
| 🐙 [appraisal-rb/appraisal2 on GitHub][📜src-gh] | Another Mirror | [💚][🤝gh-issues] | [💚][🤝gh-pulls] | [💚][📜gh-wiki] | 💯 Full Matrix | [💚][gh-discussions] |
| 🎮️ [Discord Server][✉️discord-invite] | [![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite] | [Let's][✉️discord-invite] | [talk][✉️discord-invite] | [about][✉️discord-invite] | [this][✉️discord-invite] | [library!][✉️discord-invite] |

</details>

[gh-discussions]: https://github.com/appraisal-rb/appraisal2/discussions

### Enterprise Support [![Tidelift](https://tidelift.com/badges/package/rubygems/appraisal2)](https://tidelift.com/subscription/pkg/rubygems-appraisal2?utm_source=rubygems-appraisal2&utm_medium=referral&utm_campaign=readme)

Available as part of the Tidelift Subscription.

<details markdown="1">
 <summary>Need enterprise-level guarantees?</summary>

The maintainers of this and thousands of other packages are working with Tidelift to deliver commercial support and maintenance for the open source packages you use to build your applications. Save time, reduce risk, and improve code health, while paying the maintainers of the exact packages you use.

[![Get help from me on Tidelift][🏙️entsup-tidelift-img]][🏙️entsup-tidelift]

- 💡Subscribe for support guarantees covering _all_ your FLOSS dependencies
- 💡Tidelift is part of [Sonar][🏙️entsup-tidelift-sonar]
- 💡Tidelift pays maintainers to maintain the software you depend on!<br/>📊`@`Pointy Haired Boss: An [enterprise support][🏙️entsup-tidelift] subscription is "[never gonna let you down][🧮kloc]", and *supports* open source maintainers

Alternatively:

- [![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite]
- [![Get help from me on Upwork][👨🏼‍🏫expsup-upwork-img]][👨🏼‍🏫expsup-upwork]
- [![Get help from me on Codementor][👨🏼‍🏫expsup-codementor-img]][👨🏼‍🏫expsup-codementor]

</details>

## ✨ Installation

Install the gem and add to the application's Gemfile by executing:

```console
bundle add appraisal2
```

If bundler is not being used to manage dependencies, install the gem by executing:

```console
gem install appraisal2
```

## ⚙️ Configuration

## 🔧 Basic Usage

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

The `install` and `update` **built-in commands** support several options:

**Important:** These options apply **only** to Appraisal's `install` and `update` commands.
They do **not** apply when running external commands like `bundle install` or `bundle update`.

| Option | Description |
|--------|-------------|
| `--gem-manager`, `-g` | Gem manager to use: `bundler` (default) or `ore` |
| `--jobs`, `-j` | Install gems in parallel using the given number of workers |
| `--retry` | Retry network and git requests that have failed (default: 1) |
| `--without` | A space-separated list of groups to skip during installation |
| `--full-index` | Run bundle install with the full-index argument |
| `--path` | Install gems in the specified directory |

### Using Commands with Named Appraisals

#### Using Appraisal's built-in commands with named appraisals

When using Appraisal's `install` or `update` commands with a specific appraisal name,
place the appraisal name first, then the command, then any options:

```bash
# ✅ Correct order: appraisal <NAME> <COMMAND> [OPTIONS]
bundle exec appraisal rails-7 install --gem-manager=ore
bundle exec appraisal rails-7 update rails --gem-manager=ore
bundle exec appraisal rails-7 install --jobs=4

# ❌ Wrong order (won't work)
bundle exec appraisal install rails-7 --gem-manager=ore  # Wrong order
```

More examples with Appraisal's built-in commands:

```bash
# Install dependencies for a specific appraisal
bundle exec appraisal rails-7 install

# Install with options
bundle exec appraisal rails-7 install --gem-manager=ore --jobs=4

# Update all gems in a specific appraisal
bundle exec appraisal rails-7 update

# Update specific gems in a specific appraisal
bundle exec appraisal rails-7 update rails rack
bundle exec appraisal rails-7 update rails rack --gem-manager=ore
```

#### Running external commands with named appraisals

For running external commands (like `rake test`, `rspec`, etc.) with a specific appraisal,
the structure is the same: appraisal name first, then the command:

```bash
# Run any external command with a specific appraisal's dependencies
bundle exec appraisal <APPRAISAL_NAME> <COMMAND>

# Examples:
bundle exec appraisal rails-7 rake test
bundle exec appraisal rails-7 rspec
bundle exec appraisal rails-7 rubocop

# Note: External commands do NOT support appraisal options like --gem-manager
# This doesn't work and will fail:
bundle exec appraisal rails-7 bundle install --gem-manager=ore  # ❌ Wrong
```

**Key difference:**
- `bundle exec appraisal rails-7 install --gem-manager=ore` ✅ → Uses **Appraisal's** install command with ORE
- `bundle exec appraisal rails-7 bundle install --gem-manager=ore` ❌ → Tries to run external **bundle** command (which doesn't recognize `--gem-manager`)

## 🦷 FLOSS Funding

While appraisal-rb tools are free software and will always be, the project would benefit immensely from some funding.
Raising a monthly budget of... "dollars" would make the project more sustainable.

We welcome both individual and corporate sponsors! We also offer a
wide array of funding channels to account for your preferences.
Currently, [Open Collective][🖇osc] is our preferred funding platform.

**If you're working in a company that's making significant use of appraisal-rb tools we'd
appreciate it if you suggest to your company to become a appraisal-rb sponsor.**

You can support the development of appraisal-rb tools via
[GitHub Sponsors][🖇sponsor],
[Liberapay][⛳liberapay],
[PayPal][🖇paypal],
[Open Collective][🖇osc]
and [Tidelift][🏙️entsup-tidelift].

| 📍 NOTE |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| If doing a sponsorship in the form of donation is problematic for your company <br/> from an accounting standpoint, we'd recommend the use of Tidelift, <br/> where you can get a support-like subscription instead. |

### Open Collective for Individuals

Support us with a monthly donation and help us continue our activities. [[Become a backer](https://opencollective.com/appraisal-rb#backer)]

NOTE: [kettle-readme-backers][kettle-readme-backers] updates this list every day, automatically.

<!-- OPENCOLLECTIVE-INDIVIDUALS:START -->
No backers yet. Be the first!
<!-- OPENCOLLECTIVE-INDIVIDUALS:END -->

### Open Collective for Organizations

Become a sponsor and get your logo on our README on GitHub with a link to your site. [[Become a sponsor](https://opencollective.com/appraisal-rb#sponsor)]

NOTE: [kettle-readme-backers][kettle-readme-backers] updates this list every day, automatically.

<!-- OPENCOLLECTIVE-ORGANIZATIONS:START -->
No sponsors yet. Be the first!
<!-- OPENCOLLECTIVE-ORGANIZATIONS:END -->

[kettle-readme-backers]: https://github.com/appraisal-rb/appraisal2/blob/main/exe/kettle-readme-backers

### Another way to support open-source

I’m driven by a passion to foster a thriving open-source community – a space where people can tackle complex problems, no matter how small. Revitalizing libraries that have fallen into disrepair, and building new libraries focused on solving real-world challenges, are my passions. I was recently affected by layoffs, and the tech jobs market is unwelcoming. I’m reaching out here because your support would significantly aid my efforts to provide for my family, and my farm (11 🐔 chickens, 2 🐶 dogs, 3 🐰 rabbits, 8 🐈‍ cats).

If you work at a company that uses my work, please encourage them to support me as a corporate sponsor. My work on gems you use might show up in `bundle fund`.

I’m developing a new library, [floss_funding][🖇floss-funding-gem], designed to empower open-source developers like myself to get paid for the work we do, in a sustainable way. Please give it a look.

**[Floss-Funding.dev][🖇floss-funding.dev]: 👉️ No network calls. 👉️ No tracking. 👉️ No oversight. 👉️ Minimal crypto hashing. 💡 Easily disabled nags**

[![OpenCollective Backers][🖇osc-backers-i]][🖇osc-backers] [![OpenCollective Sponsors][🖇osc-sponsors-i]][🖇osc-sponsors] [![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Donate on PayPal][🖇paypal-img]][🖇paypal] [![Buy me a coffee][🖇buyme-small-img]][🖇buyme] [![Donate on Polar][🖇polar-img]][🖇polar] [![Donate to my FLOSS efforts at ko-fi.com][🖇kofi-img]][🖇kofi] [![Donate to my FLOSS efforts using Patreon][🖇patreon-img]][🖇patreon]

## 🔐 Security

See [SECURITY.md][🔐security].

## 🤝 Contributing

If you need some ideas of where to help, you could work on adding more code coverage,
or if it is already 💯 (see [below](#code-coverage)) check [issues][🤝gh-issues] or [PRs][🤝gh-pulls],
or use the gem and think about how it could be better.

We [![Keep A Changelog][📗keep-changelog-img]][📗keep-changelog] so if you make changes, remember to update it.

See [CONTRIBUTING.md][🤝contributing] for more detailed instructions.

### 🚀 Release Instructions

See [CONTRIBUTING.md][🤝contributing].

### Code Coverage

<details markdown="1">
<summary>Coverage service badges</summary>

[![Coverage Graph][🏀codecov-g]][🏀codecov]

[![Coveralls Test Coverage][🏀coveralls-img]][🏀coveralls]

[![QLTY Test Coverage][🏀qlty-covi]][🏀qlty-cov]

</details>

### 🪇 Code of Conduct

Everyone interacting with this project's codebases, issue trackers,
chat rooms and mailing lists agrees to follow the [![Contributor Covenant 2.1][🪇conduct-img]][🪇conduct].

## 🌈 Contributors

[![Contributors][🖐contributors-img]][🖐contributors]

Made with [contributors-img][🖐contrib-rocks].

Also see GitLab Contributors: [https://gitlab.com/appraisal-rb/appraisal2/-/graphs/main][🚎contributors-gl]

<details>
 <summary>⭐️ Star History</summary>

<a href="https://star-history.com/appraisal-rb/appraisal2&Date">
 <picture>
 <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=appraisal-rb/appraisal2&type=Date&theme=dark" />
 <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=appraisal-rb/appraisal2&type=Date" />
 <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=appraisal-rb/appraisal2&type=Date" />
 </picture>
</a>

</details>

## 📌 Versioning

This library follows [![Semantic Versioning 2.0.0][📌semver-img]][📌semver] for its public API where practical.
For most applications, prefer the [Pessimistic Version Constraint][📌pvc] with two digits of precision.

For example:

```ruby
spec.add_dependency("appraisal2", "~> 3.0")
```

<details markdown="1">
<summary>📌 Is "Platform Support" part of the public API? More details inside.</summary>

Dropping support for a platform can be a breaking change for affected users.
If a release changes supported platforms, it should be called out clearly in the changelog and versioned with that impact in mind.

To get a better understanding of how SemVer is intended to work over a project's lifetime,
read this article from the creator of SemVer:

- ["Major Version Numbers are Not Sacred"][📌major-versions-not-sacred]

</details>

See [CHANGELOG.md][📌changelog] for a list of releases.

## 📄 License

The gem is available as open source under the terms of
the [MIT](MIT.md) [![License: MIT][📄license-img]][📄license-ref].

### © Copyright

See [LICENSE.md][📄license] for the official copyright notice.

<details markdown="1">
<summary>Copyright holders</summary>

- Copyright (c) 2010 Joe Ferris
- Copyright (c) 2011 Dan Croak
- Copyright (c) 2011-2012 Gabe Berke-Williams
- Copyright (c) 2011 Joe Ferris
- Copyright (c) 2011 Joseph Anthony Pasquale Holsten
- Copyright (c) 2011 Nick Quaranto
- Copyright (c) 2011 Prem Sichanugrist
- Copyright (c) 2012 Gregory Ostermayr
- Copyright (c) 2012 osheroff
- Copyright (c) 2013 Jason Waldrip
- Copyright (c) 2013 Marc Ignacio
- Copyright (c) 2013 Phill Baker
- Copyright (c) 2013-2016 Prem Sichanugrist
- Copyright (c) 2013 sanemat
- Copyright (c) 2014 Juan González
- Copyright (c) 2014-2015 Prem Sichanugrist
- Copyright (c) 2015 akihiro17
- Copyright (c) 2015 Elliot Winkler
- Copyright (c) 2015 M.Shibuya
- Copyright (c) 2015 Vlad Bokov
- Copyright (c) 2016 Geoff Massanek
- Copyright (c) 2016 Ian Fosbery
- Copyright (c) 2016 Teo Ljungberg
- Copyright (c) 2017 Brad Gessler
- Copyright (c) 2017 Oli Peate
- Copyright (c) 2017, 2025-2026 Peter H. Boling
- Copyright (c) 2018 Antonis Berkakis
- Copyright (c) 2018 Jared Beck
- Copyright (c) 2018, 2020, 2023-2024 Nick Charlton
- Copyright (c) 2020 Brian Hawley
- Copyright (c) 2020 David Rodríguez
- Copyright (c) 2020 James Ebentier
- Copyright (c) 2021, 2024 Nicolas Rodriguez
- Copyright (c) 2022 André Arko
- Copyright (c) 2022 Joe Sharp
- Copyright (c) 2023 aymeric-ledorze
- Copyright (c) 2023 Kyle Fazzari
- Copyright (c) 2024 Joe Sharp
- Copyright (c) 2024 Sebastian Cohnen
- Copyright (c) 2024 Yevhenii Ponomarenko

</details>

## 🤑 A request for help

Maintainers have teeth and need to pay their dentists.
After getting laid off in an RIF in March, and encountering difficulty finding a new one,
I began spending most of my time building open source tools.
I'm hoping to be able to pay for my kids' health insurance this month,
so if you value the work I am doing, I need your support.
Please consider sponsoring me or the project.

To join the community or get help 👇️ Join the Discord.

[![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite]

To say "thanks!" ☝️ Join the Discord or 👇️ send money.

[![Sponsor appraisal-rb/appraisal2 on Open Source Collective][🖇osc-all-bottom-img]][🖇osc] 💌 [![Sponsor me on GitHub Sponsors][🖇sponsor-bottom-img]][🖇sponsor] 💌 [![Sponsor me on Liberapay][⛳liberapay-bottom-img]][⛳liberapay] 💌 [![Donate on PayPal][🖇paypal-bottom-img]][🖇paypal]

### Please give the project a star ⭐ ♥.

Many parts of this project are actively managed by a [kettle-jem](https://github.com/structuredmerge/structuredmerge-ruby/tree/main/gems/kettle-jem) smart template utilizing [StructuredMerge.org](https://structuredmerge.org) merge contracts.

Thanks for RTFM. ☺️

[⛳liberapay-img]: https://img.shields.io/liberapay/goal/pboling.svg?logo=liberapay&color=a51611&style=flat
[⛳liberapay-bottom-img]: https://img.shields.io/liberapay/goal/pboling.svg?style=for-the-badge&logo=liberapay&color=a51611
[⛳liberapay]: https://liberapay.com/pboling/donate
[🖇osc-all-img]: https://img.shields.io/opencollective/all/appraisal-rb
[🖇osc-sponsors-img]: https://img.shields.io/opencollective/sponsors/appraisal-rb
[🖇osc-backers-img]: https://img.shields.io/opencollective/backers/appraisal-rb
[🖇osc-backers]: https://opencollective.com/appraisal-rb#backer
[🖇osc-backers-i]: https://opencollective.com/appraisal-rb/backers/badge.svg?style=flat
[🖇osc-sponsors]: https://opencollective.com/appraisal-rb#sponsor
[🖇osc-sponsors-i]: https://opencollective.com/appraisal-rb/sponsors/badge.svg?style=flat
[🖇osc-all-bottom-img]: https://img.shields.io/opencollective/all/appraisal-rb?style=for-the-badge
[🖇osc-sponsors-bottom-img]: https://img.shields.io/opencollective/sponsors/appraisal-rb?style=for-the-badge
[🖇osc-backers-bottom-img]: https://img.shields.io/opencollective/backers/appraisal-rb?style=for-the-badge
[🖇osc]: https://opencollective.com/appraisal-rb
[🖇sponsor-img]: https://img.shields.io/badge/Sponsor_Me!-pboling.svg?style=social&logo=github
[🖇sponsor-bottom-img]: https://img.shields.io/badge/Sponsor_Me!-pboling-blue?style=for-the-badge&logo=github
[🖇sponsor]: https://github.com/sponsors/pboling
[🖇polar-img]: https://img.shields.io/badge/polar-donate-a51611.svg?style=flat
[🖇polar]: https://polar.sh/pboling
[🖇kofi-img]: https://img.shields.io/badge/ko--fi-%E2%9C%93-a51611.svg?style=flat
[🖇kofi]: https://ko-fi.com/pboling
[🖇patreon-img]: https://img.shields.io/badge/patreon-donate-a51611.svg?style=flat
[🖇patreon]: https://patreon.com/galtzo
[🖇buyme-small-img]: https://img.shields.io/badge/buy_me_a_coffee-%E2%9C%93-a51611.svg?style=flat
[🖇buyme-img]: https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20latte&emoji=&slug=pboling&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff
[🖇buyme]: https://www.buymeacoffee.com/pboling
[🖇paypal-img]: https://img.shields.io/badge/donate-paypal-a51611.svg?style=flat&logo=paypal
[🖇paypal-bottom-img]: https://img.shields.io/badge/donate-paypal-a51611.svg?style=for-the-badge&logo=paypal&color=0A0A0A
[🖇paypal]: https://www.paypal.com/paypalme/peterboling
[🖇floss-funding.dev]: https://floss-funding.dev
[🖇floss-funding-gem]: https://github.com/galtzo-floss/floss_funding
[✉️discord-invite]: https://discord.gg/3qme4XHNKN
[✉️discord-invite-img-ftb]: https://img.shields.io/discord/1373797679469170758?style=for-the-badge&logo=discord
[✉️ruby-friends-img]: https://img.shields.io/badge/daily.dev-%F0%9F%92%8E_Ruby_Friends-0A0A0A?style=for-the-badge&logo=dailydotdev&logoColor=white
[✉️ruby-friends]: https://app.daily.dev/squads/rubyfriends

[✇bundle-group-pattern]: https://gist.github.com/pboling/4564780
[⛳️gem-namespace]: https://github.com/appraisal-rb/appraisal2
[⛳️namespace-img]: https://img.shields.io/badge/namespace-Appraisal2-3C2D2D.svg?style=square&logo=ruby&logoColor=white
[⛳️gem-name]: https://bestgems.org/gems/appraisal2
[⛳️name-img]: https://img.shields.io/badge/name-appraisal2-3C2D2D.svg?style=square&logo=rubygems&logoColor=red
[⛳️tag-img]: https://img.shields.io/github/tag/appraisal-rb/appraisal2.svg
[⛳️tag]: https://github.com/appraisal-rb/appraisal2/releases
[🚂maint-blog]: http://www.railsbling.com/tags/appraisal2
[🚂maint-blog-img]: https://img.shields.io/badge/blog-railsbling-0093D0.svg?style=for-the-badge&logo=rubyonrails&logoColor=orange
[🚂maint-contact]: http://www.railsbling.com/contact
[🚂maint-contact-img]: https://img.shields.io/badge/Contact-Maintainer-0093D0.svg?style=flat&logo=rubyonrails&logoColor=red
[💖🖇linkedin]: http://www.linkedin.com/in/peterboling
[💖🖇linkedin-img]: https://img.shields.io/badge/LinkedIn-Profile-0B66C2?style=flat&logo=newjapanprowrestling
[💖✌️wellfound]: https://wellfound.com/u/peter-boling
[💖✌️wellfound-img]: https://img.shields.io/badge/peter--boling-orange?style=flat&logo=wellfound
[💖💲crunchbase]: https://www.crunchbase.com/person/peter-boling
[💖💲crunchbase-img]: https://img.shields.io/badge/peter--boling-purple?style=flat&logo=crunchbase
[💖🐘ruby-mast]: https://ruby.social/@galtzo
[💖🐘ruby-mast-img]: https://img.shields.io/mastodon/follow/109447111526622197?domain=https://ruby.social&style=flat&logo=mastodon&label=Ruby%20@galtzo
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
[🏙️entsup-tidelift]: https://tidelift.com/subscription/pkg/rubygems-appraisal2?utm_source=rubygems-appraisal2&utm_medium=referral&utm_campaign=readme
[🏙️entsup-tidelift-img]: https://img.shields.io/badge/Tidelift_and_Sonar-Enterprise_Support-FD3456?style=for-the-badge&logo=sonar&logoColor=white
[🏙️entsup-tidelift-sonar]: https://blog.tidelift.com/tidelift-joins-sonar
[💁🏼‍♂️peterboling]: http://www.peterboling.com
[🚂railsbling]: http://www.railsbling.com
[📜src-gl-img]: https://img.shields.io/badge/GitLab-FBA326?style=for-the-badge&logo=Gitlab&logoColor=orange
[📜src-gl]: https://gitlab.com/appraisal-rb/appraisal2
[📜src-cb-img]: https://img.shields.io/badge/CodeBerg-4893CC?style=for-the-badge&logo=CodeBerg&logoColor=blue
[📜src-cb]: https://codeberg.org/appraisal-rb/appraisal2
[📜src-gh-img]: https://img.shields.io/badge/GitHub-238636?style=for-the-badge&logo=Github&logoColor=green
[📜src-gh]: https://github.com/appraisal-rb/appraisal2
[📜docs-cr-rd-img]: https://img.shields.io/badge/RubyDoc-Current_Release-943CD2?style=for-the-badge&logo=readthedocs&logoColor=white
[📜docs-head-rd-img]: https://img.shields.io/badge/YARD_on_Galtzo.com-HEAD-943CD2?style=for-the-badge&logo=readthedocs&logoColor=white
[📜gl-wiki]: https://gitlab.com/appraisal-rb/appraisal2/-/wikis/home
[📜gh-wiki]: https://github.com/appraisal-rb/appraisal2/wiki
[📜gl-wiki-img]: https://img.shields.io/badge/wiki-gitlab-943CD2.svg?style=for-the-badge&logo=gitlab&logoColor=white
[📜gh-wiki-img]: https://img.shields.io/badge/wiki-github-943CD2.svg?style=for-the-badge&logo=github&logoColor=white
[👽dl-rank]: https://bestgems.org/gems/appraisal2
[👽dl-ranki]: https://img.shields.io/gem/rd/appraisal2.svg
[👽version]: https://bestgems.org/gems/appraisal2
[👽versioni]: https://img.shields.io/gem/v/appraisal2.svg
[🏀qlty-mnt]: https://qlty.sh/gh/appraisal-rb/projects/appraisal2
[🏀qlty-mnti]: https://qlty.sh/gh/appraisal-rb/projects/appraisal2/maintainability.svg
[🏀qlty-cov]: https://qlty.sh/gh/appraisal-rb/projects/appraisal2/metrics/code?sort=coverageRating
[🏀qlty-covi]: https://qlty.sh/gh/appraisal-rb/projects/appraisal2/coverage.svg
[🏀codecov]: https://codecov.io/gh/appraisal-rb/appraisal2
[🏀codecovi]: https://codecov.io/gh/appraisal-rb/appraisal2/graph/badge.svg
[🏀coveralls]: https://coveralls.io/github/appraisal-rb/appraisal2?branch=main
[🏀coveralls-img]: https://coveralls.io/repos/github/appraisal-rb/appraisal2/badge.svg?branch=main
[🚎ruby-2.4-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-2.4.yml
[🚎ruby-2.5-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-2.5.yml
[🚎ruby-2.6-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-2.6.yml
[🚎ruby-2.7-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-2.7.yml
[🚎ruby-3.0-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-3.0.yml
[🚎ruby-3.1-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-3.1.yml
[🚎ruby-3.2-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-3.2.yml
[🚎ruby-3.3-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-3.3.yml
[🚎ruby-3.4-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/ruby-3.4.yml
[🚎jruby-9.2-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/jruby-9.2.yml
[🚎jruby-9.3-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/jruby-9.3.yml
[🚎jruby-9.4-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/jruby-9.4.yml
[🚎truby-22.3-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/truffleruby-22.3.yml
[🚎truby-23.0-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/truffleruby-23.0.yml
[🚎truby-23.1-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/truffleruby-23.1.yml
[🚎truby-24.2-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/truffleruby-24.2.yml
[🚎truby-25.0-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/truffleruby-25.0.yml
[🚎2-cov-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/coverage.yml
[🚎2-cov-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/coverage.yml/badge.svg
[🚎3-hd-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/heads.yml
[🚎3-hd-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/heads.yml/badge.svg
[🚎5-st-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/style.yml
[🚎5-st-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/style.yml/badge.svg
[🚎9-t-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/truffle.yml
[🚎9-t-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/truffle.yml/badge.svg
[🚎10-j-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/jruby.yml
[🚎10-j-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/jruby.yml/badge.svg
[🚎11-c-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/current.yml
[🚎11-c-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/current.yml/badge.svg
[🚎12-crh-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/dep-heads.yml
[🚎12-crh-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/dep-heads.yml/badge.svg
[🚎13-🔒️-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/locked_deps.yml
[🚎13-🔒️-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/locked_deps.yml/badge.svg
[🚎14-🔓️-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/unlocked_deps.yml
[🚎14-🔓️-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/unlocked_deps.yml/badge.svg
[🚎15-🪪-wf]: https://github.com/appraisal-rb/appraisal2/actions/workflows/license-eye.yml
[🚎15-🪪-wfi]: https://github.com/appraisal-rb/appraisal2/actions/workflows/license-eye.yml/badge.svg
[💎ruby-1.9i]: https://img.shields.io/badge/Ruby-1.9_(%F0%9F%9A%ABCI)-AABBCC?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.0i]: https://img.shields.io/badge/Ruby-2.0_(%F0%9F%9A%ABCI)-AABBCC?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.1i]: https://img.shields.io/badge/Ruby-2.1_(%F0%9F%9A%ABCI)-AABBCC?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.2i]: https://img.shields.io/badge/Ruby-2.2_(%F0%9F%9A%ABCI)-AABBCC?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.4i]: https://img.shields.io/badge/Ruby-2.4-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.5i]: https://img.shields.io/badge/Ruby-2.5-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.6i]: https://img.shields.io/badge/Ruby-2.6-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.7i]: https://img.shields.io/badge/Ruby-2.7-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.0i]: https://img.shields.io/badge/Ruby-3.0-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.1i]: https://img.shields.io/badge/Ruby-3.1-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.2i]: https://img.shields.io/badge/Ruby-3.2-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.3i]: https://img.shields.io/badge/Ruby-3.3-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.4i]: https://img.shields.io/badge/Ruby-3.4-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-4.0i]: https://img.shields.io/badge/Ruby-4.0-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-c-i]: https://img.shields.io/badge/Ruby-current-CC342D?style=for-the-badge&logo=ruby&logoColor=green
[💎ruby-headi]: https://img.shields.io/badge/Ruby-HEAD-CC342D?style=for-the-badge&logo=ruby&logoColor=blue
[💎truby-22.3i]: https://img.shields.io/badge/Truffle_Ruby-22.3-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-23.0i]: https://img.shields.io/badge/Truffle_Ruby-23.0-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-23.1i]: https://img.shields.io/badge/Truffle_Ruby-23.1-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-24.2i]: https://img.shields.io/badge/Truffle_Ruby-24.2-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-25.0i]: https://img.shields.io/badge/Truffle_Ruby-25.0-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-c-i]: https://img.shields.io/badge/Truffle_Ruby-current-34BCB1?style=for-the-badge&logo=ruby&logoColor=green
[💎jruby-9.2i]: https://img.shields.io/badge/JRuby-9.2-FBE742?style=for-the-badge&logo=ruby&logoColor=red
[💎jruby-9.3i]: https://img.shields.io/badge/JRuby-9.3-FBE742?style=for-the-badge&logo=ruby&logoColor=red
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
[🤝contributing]: https://github.com/appraisal-rb/appraisal2/blob/main/CONTRIBUTING.md
[🏀codecov-g]: https://codecov.io/gh/appraisal-rb/appraisal2/graph/badge.svg
[🖐contrib-rocks]: https://contrib.rocks
[🖐contributors]: https://github.com/appraisal-rb/appraisal2/graphs/contributors
[🖐contributors-img]: https://contrib.rocks/image?repo=appraisal-rb/appraisal2
[🚎contributors-gl]: https://gitlab.com/appraisal-rb/appraisal2/-/graphs/main
[🪇conduct]: https://github.com/appraisal-rb/appraisal2/blob/main/CODE_OF_CONDUCT.md
[🪇conduct-img]: https://img.shields.io/badge/Contributor_Covenant-2.1-259D6C.svg
[📌pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
[📌semver]: https://semver.org/spec/v2.0.0.html
[📌semver-img]: https://img.shields.io/badge/semver-2.0.0-259D6C.svg?style=flat
[📌semver-breaking]: https://github.com/semver/semver/issues/716#issuecomment-869336139
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[📌changelog]: https://github.com/appraisal-rb/appraisal2/blob/main/CHANGELOG.md
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-34495e.svg?style=flat
[📌gitmoji]: https://gitmoji.dev
[📌gitmoji-img]: https://img.shields.io/badge/gitmoji_commits-%20%F0%9F%98%9C%20%F0%9F%98%8D-34495e.svg?style=flat-square
[🧮kloc]: https://www.youtube.com/watch?v=dQw4w9WgXcQ
[🧮kloc-img]: https://img.shields.io/badge/KLOC-0.834-FFDD67.svg?style=for-the-badge&logo=YouTube&logoColor=blue
[🔐security]: https://github.com/appraisal-rb/appraisal2/blob/main/SECURITY.md
[🔐security-img]: https://img.shields.io/badge/security-policy-259D6C.svg?style=flat
[📄copyright-notice-explainer]: https://opensource.stackexchange.com/questions/5778/why-do-licenses-such-as-the-mit-license-specify-a-single-year
[📄license]: LICENSE.md
[📄license-ref]: MIT.md
[📄license-img]: https://img.shields.io/badge/License-MIT-259D6C.svg
[📄license-compat]: https://www.apache.org/legal/resolved.html#category-a
[📄license-compat-img]: https://img.shields.io/badge/Apache_Compatible:_Category_A-✓-259D6C.svg?style=flat&logo=Apache

[📄ilo-declaration]: https://www.ilo.org/declaration/lang--en/index.htm
[📄ilo-declaration-img]: https://img.shields.io/badge/ILO_Fundamental_Principles-✓-259D6C.svg?style=flat
[🚎yard-current]: http://rubydoc.info/gems/appraisal2
[🚎yard-head]: https://appraisal2.galtzo.com
[💎stone_checksums]: https://github.com/galtzo-floss/stone_checksums
[💎SHA_checksums]: https://gitlab.com/appraisal-rb/appraisal2/-/tree/main/checksums
[💎rlts]: https://github.com/rubocop-lts/rubocop-lts
[💎rlts-img]: https://img.shields.io/badge/code_style_&_linting-rubocop--lts-34495e.svg?plastic&logo=ruby&logoColor=white
[💎appraisal2]: https://github.com/appraisal-rb/appraisal2
[💎appraisal2-img]: https://img.shields.io/badge/appraised_by-appraisal2-34495e.svg?plastic&logo=ruby&logoColor=white
[💎d-in-dvcs]: https://railsbling.com/posts/dvcs/put_the_d_in_dvcs/

<!-- kettle-jem:metadata:start -->
| Field | Value |
|---|---|
| Package | appraisal2 |
| Description | 🔍️ Appraisal2 integrates with bundler and rake to test your library against different versions of dependencies in repeatable scenarios called "appraisals." |
| Homepage | https://github.com/appraisal-rb/appraisal2 |
| Source | https://github.com/appraisal-rb/appraisal2/tree/v3.0.7 |
| License | `MIT` |
| Funding | https://github.com/sponsors/pboling, https://issuehunt.io/u/pboling, https://ko-fi.com/pboling, https://liberapay.com/pboling/donate, https://opencollective.com/appraisal-rb, https://patreon.com/galtzo, https://polar.sh/pboling, https://thanks.dev/u/gh/pboling, https://tidelift.com/funding/github/rubygems/appraisal2, https://www.buymeacoffee.com/pboling |
<!-- kettle-jem:metadata:end -->
