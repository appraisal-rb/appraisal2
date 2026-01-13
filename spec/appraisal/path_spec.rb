# frozen_string_literal: true

require "appraisal/path"

RSpec.describe Appraisal::Path do
  describe "#to_s" do
    context "without options" do
      subject(:path) { described_class.new("../my_gem") }

      it "wraps content in path block" do
        path.gem "my_gem"
        output = path.to_s

        expect(output).to include("path")
        expect(output).to include("../my_gem")
        expect(output).to include('gem "my_gem"')
        expect(output).to include("end")
      end
    end

    context "with options" do
      subject(:path) { described_class.new("../my_gem", :require => false) }

      it "includes options in the path block" do
        path.gem "my_gem"
        output = path.to_s

        expect(output).to include("path")
        expect(output).to include("../my_gem")
        expect(output).to include(":require")
        expect(output).to include('gem "my_gem"')
      end
    end
  end

  describe "#for_dup" do
    context "without options" do
      subject(:path) { described_class.new("/absolute/path/to/gem") }

      it "returns the path block for duplication" do
        path.gem "local_gem"
        output = path.for_dup

        expect(output).to include("path")
        expect(output).to include("/absolute/path/to/gem")
        expect(output).to include('gem "local_gem"')
      end
    end

    context "with options" do
      subject(:path) { described_class.new("/path/to/gem", :glob => "*.gemspec") }

      it "includes options in the duplicated block" do
        path.gem "globbed_gem"
        output = path.for_dup

        expect(output).to include("path")
        expect(output).to include("/path/to/gem")
        expect(output).to include(":glob")
      end
    end
  end
end
