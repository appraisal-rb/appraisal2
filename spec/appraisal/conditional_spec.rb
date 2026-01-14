# frozen_string_literal: true

require "appraisal/conditional"

RSpec.describe Appraisal::Conditional do
  subject(:conditional) { described_class.new(condition) }

  describe "#to_s" do
    context "with a proc condition" do
      let(:condition) { "-> { RUBY_VERSION >= '2.5' }" }

      it "wraps content in install_if block" do
        conditional.gem "test_gem", "1.0.0"
        output = conditional.to_s

        expect(output).to include("install_if -> { RUBY_VERSION >= '2.5' } do")
        expect(output).to include('gem "test_gem", "1.0.0"')
        expect(output).to include("end")
      end
    end

    context "with a symbol condition" do
      let(:condition) { ":mri" }

      it "wraps content in install_if block" do
        conditional.gem "mri_only_gem"
        output = conditional.to_s

        expect(output).to include("install_if :mri do")
        expect(output).to include('gem "mri_only_gem"')
      end
    end
  end

  describe "#for_dup" do
    context "with a string condition" do
      let(:condition) { "-> { true }" }

      it "returns the install_if block for duplication" do
        conditional.gem "dup_gem"
        output = conditional.for_dup

        expect(output).to include("install_if -> { true } do")
        expect(output).to include('gem "dup_gem"')
      end
    end

    context "with a non-string condition" do
      let(:condition) { :mri }

      it "returns nil" do
        conditional.gem "test_gem"
        expect(conditional.for_dup).to be_nil
      end
    end
  end
end
