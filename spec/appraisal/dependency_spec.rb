# frozen_string_literal: true

require "appraisal/dependency"

RSpec.describe Appraisal::Dependency do
  describe "#to_s" do
    context "with no requirements" do
      it "returns just the gem name" do
        dependency = described_class.new("rails", [])
        expect(dependency.to_s).to eq('gem "rails"')
      end
    end

    context "with version requirement" do
      it "includes the version" do
        dependency = described_class.new("rails", ["~> 7.0"])
        expect(dependency.to_s).to include('gem "rails"')
        expect(dependency.to_s).to include('"~> 7.0"')
      end
    end

    context "with multiple requirements" do
      it "includes all requirements" do
        dependency = described_class.new("rails", [">= 6.0", "< 8.0"])
        output = dependency.to_s
        expect(output).to include('gem "rails"')
        expect(output).to include('">= 6.0"')
        expect(output).to include('"< 8.0"')
      end
    end

    context "with path requirement" do
      it "prefixes the path" do
        dependency = described_class.new("my_gem", [{:path => "../my_gem"}])
        output = dependency.to_s
        expect(output).to include('gem "my_gem"')
        expect(output).to include(":path")
      end
    end

    context "with git requirement" do
      it "prefixes the git path" do
        dependency = described_class.new("my_gem", [{:git => "../my_repo"}])
        output = dependency.to_s
        expect(output).to include('gem "my_gem"')
        expect(output).to include(":git")
      end
    end
  end

  describe "#for_dup" do
    it "returns the dependency formatted for duplication" do
      dependency = described_class.new("rails", ["~> 7.0"])
      output = dependency.for_dup
      expect(output).to include('gem "rails"')
      expect(output).to include('"~> 7.0"')
    end
  end

  describe "#requirements=" do
    it "allows updating requirements" do
      dependency = described_class.new("rails", ["~> 6.0"])
      dependency.requirements = ["~> 7.0"]
      expect(dependency.to_s).to include('"~> 7.0"')
    end
  end

  describe "#name" do
    it "returns the gem name" do
      dependency = described_class.new("rails", [])
      expect(dependency.name).to eq("rails")
    end
  end
end
