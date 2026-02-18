# frozen_string_literal: true

require "appraisal/version"

RSpec.describe "CLI", ".install with named appraisal" do
  context "when targeting a specific appraisal" do
    before do
      build_appraisal_file <<-APPRAISAL.strip_heredoc.rstrip
        appraise 'rails-6' do
          gem 'dummy', '1.0.0'
        end

        appraise 'rails-7' do
          gem 'dummy', '1.1.0'
        end
      APPRAISAL
    end

    it "installs dependencies for only the named appraisal" do
      run "appraisal rails-7 install"

      expect(file("gemfiles/rails_7.gemfile.lock")).to be_exists
      expect(content_of("gemfiles/rails_7.gemfile.lock")).to include("dummy (1.1.0)")
    end

    it "accepts --gem-manager option" do
      output = run "appraisal rails-7 install --gem-manager=bundler"

      expect(output).to include("bundle install")
      expect(output).to include("gemfiles/rails_7.gemfile")
      expect(file("gemfiles/rails_7.gemfile.lock")).to be_exists
    end

    it "accepts -g shorthand for gem-manager" do
      output = run "appraisal rails-7 install -g bundler"

      expect(output).to include("bundle install")
      expect(output).to include("gemfiles/rails_7.gemfile")
      expect(file("gemfiles/rails_7.gemfile.lock")).to be_exists
    end

    it "accepts --jobs option with named appraisal", :parallel do
      output = run "appraisal rails-7 install --jobs=2"

      expect(output).to include("bundle install")
      expect(output).to include("gemfiles/rails_7.gemfile")
      expect(output).to match(/--jobs[\\= ]2/)
      expect(file("gemfiles/rails_7.gemfile.lock")).to be_exists
    end

    it "accepts multiple options with named appraisal", :parallel do
      output = run "appraisal rails-7 install --gem-manager=bundler --jobs=2"

      expect(output).to include("bundle install")
      expect(output).to include("gemfiles/rails_7.gemfile")
      expect(output).to match(/--jobs[\\= ]2/)
      expect(file("gemfiles/rails_7.gemfile.lock")).to be_exists
    end

    it "does not install other appraisals" do
      run "appraisal rails-7 install"

      expect(file("gemfiles/rails_7.gemfile.lock")).to be_exists
      expect(file("gemfiles/rails_6.gemfile.lock")).not_to be_exists
    end
  end

  context "with ore gem manager", :ore do
    before do
      build_appraisal_file <<-APPRAISAL.strip_heredoc.rstrip
        appraise 'rails-7' do
          gem 'status_tag', '~> 0.2'
        end
      APPRAISAL
    end

    it "installs using ore when --gem-manager=ore is specified" do
      skip "ore not available" unless ore_available?

      output = run "appraisal rails-7 install --gem-manager=ore"

      expect(output).to include("ore install")
      expect(file("gemfiles/rails_7.gemfile.lock")).to be_exists
    end

    it "installs using ore with short flag -g ore" do
      skip "ore not available" unless ore_available?

      output = run "appraisal rails-7 install -g ore"

      expect(output).to include("ore install")
      expect(file("gemfiles/rails_7.gemfile.lock")).to be_exists
    end
  end

  context "with bundler version switching" do
    before do
      # Create an appraisal with a pre-existing lockfile that specifies a bundler version
      # appropriate for the current Ruby version.
      # This tests that appraisal can handle locked bundler versions in gemfiles/*.gemfile.lock
      # across all supported Ruby versions (2.3 through 4.0+).
      build_appraisal_file <<-APPRAISAL.strip_heredoc.rstrip
        appraise 'bundler-locked' do
          gem 'dummy', '1.0.0'
        end
      APPRAISAL

      # Create the gemfiles directory
      in_test_directory { FileUtils.mkdir_p("gemfiles") }

      # Select bundler version based on current Ruby version
      # Each version is compatible with the Ruby version but not a default,
      # ensuring we always test version switching capability
      # See: https://dev.to/galtzo/matrix-ruby-gem-bundler-etc-4kk7
      bundler_version_for_ruby = {
        # Ruby 2.3, 2.4, 2.5
        "2.3" => "2.3.24",
        "2.4" => "2.3.25",
        "2.5" => "2.3.26",
        # Ruby 2.6, 2.7
        "2.6" => "2.4.20",
        "2.7" => "2.4.21",
        # Ruby 3.0
        "3.0" => "2.5.22",
        # Ruby 3.1
        "3.1" => "2.6.8",
        # Ruby 3.2
        "3.2" => "2.7.1",
        # Ruby 3.3, 3.4, 4.0
        "3.3" => "4.0.3",
        "3.4" => "4.0.4",
        "4.0" => "4.0.5",
      }

      # Get the current Ruby version (major.minor)
      ruby_version = "#{RUBY_VERSION.split(".")[0]}.#{RUBY_VERSION.split(".")[1]}"

      # Look up the bundler version for this Ruby version
      # Default to 4.0.3 for unknown Ruby versions (4.0.3 is less likely to be system default than 4.0.5 or 4.0.6)
      locked_bundler_version = bundler_version_for_ruby.fetch(ruby_version, "4.0.3")

      # Pre-create the gemfile with the appropriate bundler version
      # Note: We DO NOT include bundler as a gem dependency here.
      # The bundler version is specified only in BUNDLED WITH in the lockfile,
      # which tells bundler what version was used to generate the lockfile.
      write_file "gemfiles/bundler_locked.gemfile", <<-GEMFILE.strip_heredoc
        source "https://gem.coop"

        gem "appraisal2", :path => "../appraisal2"
        gem "dummy", "1.0.0"
      GEMFILE

      run "BUNDLE_LOCKFILE=gemfiles/bundler_locked.gemfile.lock bundle install --gemfile 'gemfiles/bundler_locked.gemfile'"

      lockfile_path = file("gemfiles/bundler_locked.gemfile.lock")
      lockfile_content = lockfile_path.read
      bundled_with = lockfile_content[/BUNDLED WITH\s*\n\s*([^\s]+)/, 1]

      decrement_patch = lambda do |version|
        parts = version.to_s.split(".")
        return version unless parts.last =~ /^\d+$/
        patch = parts.last.to_i
        return version if patch.zero?

        parts[-1] = (patch - 1).to_s
        parts.join(".")
      end

      locked_bundler_version = decrement_patch.call(bundled_with || locked_bundler_version)
      lockfile_content.sub!(/(BUNDLED WITH\s*\n\s*)([^\s]+)/, "\\1#{locked_bundler_version}")
      lockfile_path.write(lockfile_content)

      @locked_bundler_version = locked_bundler_version
    end

    it "respects bundler version specified in appraisal gemfile.lock" do
      skip_for(:engine => "jruby", :reason => "Hi, I'm JRuby, and I'm different")
      skip_for(:engine => "truffleruby", :reason => "Upgrading bundler on Truffleruby is not a thing")
      # This test verifies that appraisal can handle lockfiles with BUNDLED WITH specified,
      # and that the bundler version is preserved/respected through the install process.
      # This is critical for users who commit their appraisal lockfiles to ensure stable,
      # repeatable builds in CI.
      output = run "appraisal bundler-locked install"

      expect(output).to include("bundle install")
      expect(output).to include("gemfiles/bundler_locked.gemfile")
      expect(file("gemfiles/bundler_locked.gemfile.lock")).to be_exists

      # The lockfile should maintain the BUNDLED WITH version specified
      lockfile_content = content_of("gemfiles/bundler_locked.gemfile.lock")
      expect(lockfile_content).to include("BUNDLED WITH")
      expect(lockfile_content).to include(@locked_bundler_version)
    end
  end
end
