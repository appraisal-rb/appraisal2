# frozen_string_literal: true

require "appraisal/source"

RSpec.describe Appraisal::Source do
  subject(:source) { described_class.new(source_url) }

  let(:source_url) { "https://gem.coop" }

  describe "#to_s" do
    it "wraps content in source block" do
      source.gem "test_gem", "1.0.0"
      output = source.to_s

      expect(output).to include('source "https://gem.coop" do')
      expect(output).to include('gem "test_gem", "1.0.0"')
      expect(output).to include("end")
    end

    context "with a different source" do
      let(:source_url) { "https://gems.example.com" }

      it "uses the correct source URL" do
        source.gem "private_gem"
        output = source.to_s

        expect(output).to include('source "https://gems.example.com" do')
      end
    end
  end

  describe "#for_dup" do
    it "returns the source block for duplication" do
      source.gem "dup_gem"
      output = source.for_dup

      expect(output).to include('source "https://gem.coop" do')
      expect(output).to include('gem "dup_gem"')
    end
  end
end
