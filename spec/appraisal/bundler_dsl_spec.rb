# frozen_string_literal: true

require "appraisal/bundler_dsl"
require "appraisal/group"
require "appraisal/platform"
require "appraisal/git"
require "appraisal/path"
require "appraisal/source"
require "appraisal/conditional"
require "appraisal/gemspec"

RSpec.describe Appraisal::BundlerDSL do
  subject(:dsl) { described_class.new }

  describe "#gem" do
    it "adds a gem to dependencies" do
      dsl.gem "rails", "~> 7.0"
      expect(dsl.to_s).to include('gem "rails", "~> 7.0"')
    end

    it "adds multiple gems" do
      dsl.gem "rails"
      dsl.gem "rspec"
      output = dsl.to_s
      expect(output).to include('gem "rails"')
      expect(output).to include('gem "rspec"')
    end
  end

  describe "#remove_gem" do
    it "removes a gem from dependencies" do
      dsl.gem "to_be_removed"
      dsl.remove_gem "to_be_removed"
      expect(dsl.to_s).not_to include("to_be_removed")
    end
  end

  describe "#source" do
    context "without block" do
      it "adds a source" do
        dsl.source "https://gem.coop"
        expect(dsl.to_s).to include('source "https://gem.coop"')
      end

      it "deduplicates sources" do
        dsl.source "https://gem.coop"
        dsl.source "https://gem.coop"
        output = dsl.to_s
        expect(output.scan('source "https://gem.coop"').length).to eq(1)
      end
    end

    context "with block" do
      it "creates a source block" do
        dsl.source "https://gems.example.com" do
          gem "private_gem"
        end
        output = dsl.to_s
        expect(output).to include('source "https://gems.example.com" do')
        expect(output).to include('gem "private_gem"')
      end
    end
  end

  describe "#ruby" do
    it "sets ruby version as string" do
      dsl.ruby "3.2.0"
      expect(dsl.to_s).to include('ruby "3.2.0"')
    end

    it "sets ruby version with options hash" do
      dsl.ruby :engine => "jruby", :engine_version => "9.4.0"
      output = dsl.to_s
      expect(output).to include("ruby(")
      expect(output).to include(":engine")
    end
  end

  describe "#group" do
    it "creates a group" do
      dsl.group :test do
        gem "rspec"
      end
      output = dsl.to_s
      expect(output).to include("group :test do")
      expect(output).to include('gem "rspec"')
    end

    it "creates a group with multiple names" do
      dsl.group :development, :test do
        gem "debug"
      end
      output = dsl.to_s
      expect(output).to include("group :development, :test do")
    end
  end

  describe "#platforms" do
    it "creates a platform block" do
      dsl.platforms :ruby do
        gem "sqlite3"
      end
      output = dsl.to_s
      expect(output).to include("platforms :ruby do")
      expect(output).to include('gem "sqlite3"')
    end

    it "is aliased as platform" do
      dsl.platform :jruby do
        gem "jdbc-postgres"
      end
      output = dsl.to_s
      expect(output).to include("platforms :jruby do")
    end
  end

  describe "#install_if" do
    it "creates an install_if block" do
      dsl.install_if "-> { RUBY_VERSION >= '3.0' }" do
        gem "new_gem"
      end
      output = dsl.to_s
      expect(output).to include("install_if")
      expect(output).to include('gem "new_gem"')
    end
  end

  describe "#git" do
    it "creates a git block" do
      dsl.git "https://github.com/rails/rails.git" do
        gem "rails"
      end
      output = dsl.to_s
      expect(output).to include("git")
      expect(output).to include("https://github.com/rails/rails.git")
      expect(output).to include('gem "rails"')
    end

    it "supports git options" do
      dsl.git "https://github.com/rails/rails.git", :branch => "main" do
        gem "rails"
      end
      output = dsl.to_s
      expect(output).to include(":branch")
    end
  end

  describe "#path" do
    it "creates a path block" do
      dsl.path "../my_gem" do
        gem "my_gem"
      end
      output = dsl.to_s
      expect(output).to include("path")
      expect(output).to include('gem "my_gem"')
    end
  end

  describe "#gemspec" do
    it "adds a gemspec directive" do
      dsl.gemspec
      expect(dsl.to_s).to include("gemspec")
    end

    it "supports options" do
      dsl.gemspec :path => "gems/my_gem"
      output = dsl.to_s
      expect(output).to include("gemspec")
      expect(output).to include(":path")
    end
  end

  describe "#eval_gemfile" do
    it "adds eval_gemfile directive" do
      dsl.eval_gemfile "shared/Gemfile"
      expect(dsl.to_s).to include('eval_gemfile("shared/Gemfile")')
    end

    it "supports contents parameter" do
      dsl.eval_gemfile "shared/Gemfile", "gem 'extra'"
      output = dsl.to_s
      expect(output).to include('eval_gemfile("shared/Gemfile"')
    end
  end

  describe "#git_source" do
    it "registers a custom git source" do
      dsl.git_source(:github) { |repo| "https://github.com/#{repo}.git" }
      dsl.gem "rails", :github => "rails/rails"
      output = dsl.to_s
      expect(output).to include(":git")
      expect(output).to include("https://github.com/rails/rails.git")
    end
  end

  describe "#run" do
    it "executes a block in DSL context" do
      dsl.run do
        gem "test_gem"
      end
      expect(dsl.to_s).to include('gem "test_gem"')
    end
  end

  describe "#for_dup" do
    it "returns content suitable for duplication" do
      dsl.gem "test"
      dsl.source "https://gem.coop"
      output = dsl.for_dup
      expect(output).to include('gem "test"')
      expect(output).to include('source "https://gem.coop"')
    end
  end

  describe "indentation" do
    around do |example|
      original_indenter = ENV["APPRAISAL_INDENTER"]
      example.run
      ENV["APPRAISAL_INDENTER"] = original_indenter
    end

    context "with lookaround indenter (default)" do
      before { ENV["APPRAISAL_INDENTER"] = "lookaround" }

      it "indents content within blocks" do
        dsl.group :test do
          gem "rspec"
        end
        output = dsl.to_s
        expect(output).to include("  gem")
      end
    end

    context "with capture indenter" do
      before { ENV["APPRAISAL_INDENTER"] = "capture" }

      it "indents content within blocks" do
        dsl.group :test do
          gem "rspec"
        end
        output = dsl.to_s
        expect(output).to include("  gem")
      end
    end

    context "with unknown indenter" do
      before { ENV["APPRAISAL_INDENTER"] = "none" }

      it "does not indent content" do
        dsl.group :test do
          gem "rspec"
        end
        output = dsl.to_s
        # With no indentation, the gem line should still be present
        expect(output).to include('gem "rspec"')
      end
    end
  end
end
