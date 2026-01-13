# frozen_string_literal: true

require "appraisal/group"

RSpec.describe Appraisal::Group do
  describe "#to_s" do
    it "wraps content in group block with single group name" do
      group = described_class.new([:test])
      group.gem "rspec"
      output = group.to_s

      expect(output).to include("group :test do")
      expect(output).to include('gem "rspec"')
      expect(output).to include("end")
    end

    it "wraps content in group block with multiple group names" do
      group = described_class.new([:development, :test])
      group.gem "debug"
      output = group.to_s

      expect(output).to include("group :development, :test do")
      expect(output).to include('gem "debug"')
    end
  end

  describe "#for_dup" do
    it "returns the group block for duplication" do
      group = described_class.new([:test])
      group.gem "dup_gem"
      output = group.for_dup

      expect(output).to include("group :test do")
      expect(output).to include('gem "dup_gem"')
    end
  end
end
