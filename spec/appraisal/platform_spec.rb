# frozen_string_literal: true

require "appraisal/platform"

RSpec.describe Appraisal::Platform do
  describe "#to_s" do
    it "wraps content in platforms block with single platform" do
      platform = described_class.new([:ruby])
      platform.gem "sqlite3"
      output = platform.to_s

      expect(output).to include("platforms :ruby do")
      expect(output).to include('gem "sqlite3"')
      expect(output).to include("end")
    end

    it "wraps content in platforms block with multiple platforms" do
      platform = described_class.new([:ruby, :mri])
      platform.gem "byebug"
      output = platform.to_s

      expect(output).to include("platforms :ruby, :mri do")
      expect(output).to include('gem "byebug"')
    end
  end

  describe "#for_dup" do
    it "returns the platforms block for duplication" do
      platform = described_class.new([:jruby])
      platform.gem "jdbc_gem"
      output = platform.for_dup

      expect(output).to include("platforms :jruby do")
      expect(output).to include('gem "jdbc_gem"')
    end
  end
end
