# frozen_string_literal: true

require "appraisal/errors"

RSpec.describe "Appraisal errors" do
  describe Appraisal::AppraisalsNotFound do
    subject(:error) { described_class.new }

    describe "#message" do
      it "returns the expected message" do
        expect(error.message).to eq("Unable to locate 'Appraisals' file in the current directory.")
      end
    end
  end

  describe Appraisal::OreNotAvailableError do
    subject(:error) { described_class.new }

    describe "#message" do
      it "returns the expected message" do
        expect(error.message).to include("ore-light is not installed")
        expect(error.message).to include("https://github.com/contriboss/ore-light")
      end
    end
  end

  describe Appraisal::UnknownGemManagerError do
    subject(:error) { described_class.new("unknown_manager", %w[bundler ore]) }

    describe "#message" do
      it "returns the expected message with manager name" do
        expect(error.message).to include("Unknown gem manager: 'unknown_manager'")
      end

      it "lists available managers" do
        expect(error.message).to include("Available: bundler, ore")
      end
    end
  end
end
