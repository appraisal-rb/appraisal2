# frozen_string_literal: true

require "appraisal/gem_manager/factory"
require "appraisal/errors"

RSpec.describe Appraisal::GemManager::Factory do
  let(:gemfile_path) { "/path/to/gemfile" }
  let(:project_root) { Pathname.new("/path/to") }

  describe ".create" do
    context "with bundler manager" do
      it "returns a BundlerAdapter" do
        adapter = described_class.create(gemfile_path, project_root, :manager => "bundler")
        expect(adapter).to be_a(Appraisal::GemManager::BundlerAdapter)
      end
    end

    context "with nil manager" do
      it "defaults to bundler" do
        adapter = described_class.create(gemfile_path, project_root, :manager => nil)
        expect(adapter).to be_a(Appraisal::GemManager::BundlerAdapter)
      end
    end

    context "with empty string manager" do
      it "defaults to bundler" do
        adapter = described_class.create(gemfile_path, project_root, :manager => "")
        expect(adapter).to be_a(Appraisal::GemManager::BundlerAdapter)
      end
    end

    context "with whitespace-only manager" do
      it "defaults to bundler" do
        adapter = described_class.create(gemfile_path, project_root, :manager => "  ")
        expect(adapter).to be_a(Appraisal::GemManager::BundlerAdapter)
      end
    end

    context "with uppercase manager name" do
      it "normalizes to lowercase" do
        adapter = described_class.create(gemfile_path, project_root, :manager => "BUNDLER")
        expect(adapter).to be_a(Appraisal::GemManager::BundlerAdapter)
      end
    end

    context "with ore manager", :ore do
      it "returns an OreAdapter when ore is available" do
        adapter = described_class.create(gemfile_path, project_root, :manager => "ore")
        expect(adapter).to be_a(Appraisal::GemManager::OreAdapter)
      end
    end

    context "with ore manager when ore is not installed" do
      it "raises OreNotAvailableError" do
        # Create the adapter first, then stub its available? method
        ore_adapter = Appraisal::GemManager::OreAdapter.new(gemfile_path, project_root)
        allow(ore_adapter).to receive(:available?).and_return(false)
        allow(Appraisal::GemManager::OreAdapter).to receive(:new).and_return(ore_adapter)

        expect {
          described_class.create(gemfile_path, project_root, :manager => "ore")
        }.to raise_error(Appraisal::OreNotAvailableError)
      end
    end

    context "with unknown manager" do
      it "raises UnknownGemManagerError" do
        expect {
          described_class.create(gemfile_path, project_root, :manager => "unknown")
        }.to raise_error(Appraisal::UnknownGemManagerError)
      end
    end
  end

  describe ".available_managers" do
    it "returns list of available manager names" do
      expect(described_class.available_managers).to contain_exactly("bundler", "ore")
    end
  end
end
