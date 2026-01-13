# frozen_string_literal: true

require "appraisal/ordered_hash"

RSpec.describe Appraisal::OrderedHash do
  subject(:hash) { described_class.new }

  describe "basic hash operations" do
    it "behaves like a regular hash" do
      hash[:key1] = "value1"
      hash[:key2] = "value2"

      expect(hash[:key1]).to eq("value1")
      expect(hash[:key2]).to eq("value2")
    end

    it "returns values" do
      hash[:a] = 1
      hash[:b] = 2
      hash[:c] = 3

      expect(hash.values).to contain_exactly(1, 2, 3)
    end

    it "supports has_key?" do
      hash[:existing] = "value"

      expect(hash.has_key?(:existing)).to be true
      expect(hash.has_key?(:missing)).to be false
    end
  end

  describe "initialization" do
    it "can be initialized with a default value" do
      hash_with_default = described_class.new("default")
      expect(hash_with_default[:missing]).to eq("default")
    end

    it "can be initialized with a block" do
      hash_with_block = described_class.new { |h, k| h[k] = k.to_s.upcase }
      hash_with_block[:test]
      expect(hash_with_block[:test]).to eq("TEST")
    end
  end
end
