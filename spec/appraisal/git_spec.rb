# frozen_string_literal: true

require "appraisal/git"

RSpec.describe Appraisal::Git do
  describe "#to_s" do
    context "without options" do
      subject(:git) { described_class.new("https://github.com/rails/rails.git") }

      it "wraps content in git block" do
        git.gem "rails"
        output = git.to_s

        expect(output).to include('git "https://github.com/rails/rails.git" do')
        expect(output).to include('gem "rails"')
        expect(output).to include("end")
      end
    end

    context "with options" do
      subject(:git) { described_class.new("https://github.com/rails/rails.git", :branch => "main") }

      it "includes options in the git block" do
        git.gem "rails"
        output = git.to_s

        expect(output).to include('git "https://github.com/rails/rails.git"')
        expect(output).to include(":branch")
        expect(output).to include('"main"')
        expect(output).to include('gem "rails"')
      end
    end

    context "with tag option" do
      subject(:git) { described_class.new("https://github.com/rails/rails.git", :tag => "v7.0.0") }

      it "includes tag in the git block" do
        git.gem "rails"
        output = git.to_s

        expect(output).to include(":tag")
        expect(output).to include('"v7.0.0"')
      end
    end
  end

  describe "#for_dup" do
    context "without options" do
      subject(:git) { described_class.new("https://github.com/example/gem.git") }

      it "returns the git block for duplication" do
        git.gem "example"
        output = git.for_dup

        expect(output).to include('git "https://github.com/example/gem.git" do')
        expect(output).to include('gem "example"')
      end
    end

    context "with options" do
      subject(:git) { described_class.new("https://github.com/example/gem.git", :ref => "abc123") }

      it "includes options in the duplicated block" do
        git.gem "example"
        output = git.for_dup

        expect(output).to include('git "https://github.com/example/gem.git"')
        expect(output).to include(":ref")
        expect(output).to include('"abc123"')
      end
    end
  end
end
