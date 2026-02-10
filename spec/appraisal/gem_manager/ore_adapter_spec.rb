# frozen_string_literal: true

require "appraisal/gem_manager/ore_adapter"
require "appraisal/errors"

RSpec.describe Appraisal::GemManager::OreAdapter do
  subject(:adapter) { described_class.new(gemfile_path, project_root) }

  let(:gemfile_path) { "/home/test/test directory/gemfile" }
  let(:project_root) { Pathname.new("/home/test") }

  describe "#name" do
    it "returns 'ore'" do
      expect(adapter.name).to eq("ore")
    end
  end

  describe "#available?" do
    context "when ore is installed" do
      before do
        allow(adapter).to receive(:system).with("which ore > /dev/null 2>&1").and_return(true)
      end

      it "returns true" do
        expect(adapter.available?).to be true
      end
    end

    context "when ore is not installed" do
      before do
        allow(adapter).to receive(:system).with("which ore > /dev/null 2>&1").and_return(false)
      end

      it "returns false" do
        expect(adapter.available?).to be false
      end
    end
  end

  describe "#validate_availability!" do
    context "when ore is available" do
      before do
        allow(adapter).to receive(:system).with("which ore > /dev/null 2>&1").and_return(true)
      end

      it "does not raise an error" do
        expect { adapter.validate_availability! }.not_to raise_error
      end
    end

    context "when ore is not available" do
      before do
        allow(adapter).to receive(:system).with("which ore > /dev/null 2>&1").and_return(false)
      end

      it "raises OreNotAvailableError" do
        expect { adapter.validate_availability! }.to raise_error(Appraisal::OreNotAvailableError)
      end
    end
  end

  describe "#install", :ore do
    before do
      allow(adapter).to receive(:system).with("which ore > /dev/null 2>&1").and_return(true)
      allow(Bundler).to receive(:with_original_env).and_yield
      allow(Appraisal::Command).to receive(:new).and_return(double(:run => true))
      allow(adapter).to receive(:puts)
      # Simulate lockfile exists by default
      allow(File).to receive(:exist?).with("#{gemfile_path}.lock").and_return(true)
    end

    it "runs ore install command" do
      adapter.install

      expect(Appraisal::Command).to have_received(:new).with(
        ["ore", "install", "-lockfile=#{gemfile_path}.lock"],
        :gemfile => gemfile_path,
        :skip_bundle_exec => true,
      )
    end

    context "when lockfile does not exist" do
      before do
        allow(File).to receive(:exist?).with("#{gemfile_path}.lock").and_return(false)
      end

      it "runs ore lock first, then ore install" do
        adapter.install

        expect(Appraisal::Command).to have_received(:new).with(
          ["ore", "lock", "-gemfile", gemfile_path],
          :gemfile => gemfile_path,
          :skip_bundle_exec => true,
        ).ordered
        expect(Appraisal::Command).to have_received(:new).with(
          ["ore", "install", "-lockfile=#{gemfile_path}.lock"],
          :gemfile => gemfile_path,
          :skip_bundle_exec => true,
        ).ordered
      end
    end

    context "with jobs option" do
      it "includes -workers flag when jobs > 1" do
        adapter.install("jobs" => 4)

        expect(Appraisal::Command).to have_received(:new).with(
          ["ore", "install", "-workers=4", "-lockfile=#{gemfile_path}.lock"],
          :gemfile => gemfile_path,
          :skip_bundle_exec => true,
        )
      end

      it "does not include -workers flag when jobs is 1" do
        adapter.install("jobs" => 1)

        expect(Appraisal::Command).to have_received(:new).with(
          ["ore", "install", "-lockfile=#{gemfile_path}.lock"],
          :gemfile => gemfile_path,
          :skip_bundle_exec => true,
        )
      end
    end

    context "with retry option" do
      it "ignores retry option (ore does not support it)" do
        adapter.install("retry" => 3)

        expect(Appraisal::Command).to have_received(:new).with(
          ["ore", "install", "-lockfile=#{gemfile_path}.lock"],
          :gemfile => gemfile_path,
          :skip_bundle_exec => true,
        )
      end
    end

    context "with without option" do
      it "includes -without flag with comma-separated groups" do
        adapter.install("without" => "development test")

        expect(Appraisal::Command).to have_received(:new).with(
          ["ore", "install", "-without=development,test", "-lockfile=#{gemfile_path}.lock"],
          :gemfile => gemfile_path,
          :skip_bundle_exec => true,
        )
      end

      it "does not include -without flag when empty" do
        adapter.install("without" => "")

        expect(Appraisal::Command).to have_received(:new).with(
          ["ore", "install", "-lockfile=#{gemfile_path}.lock"],
          :gemfile => gemfile_path,
          :skip_bundle_exec => true,
        )
      end
    end

    context "with path option" do
      it "includes -vendor flag with resolved path" do
        adapter.install("path" => "vendor/bundle")

        expect(Appraisal::Command).to have_received(:new).with(
          ["ore", "install", "-vendor=/home/test/vendor/bundle", "-lockfile=#{gemfile_path}.lock"],
          :gemfile => gemfile_path,
          :skip_bundle_exec => true,
        )
      end
    end

    context "with multiple options" do
      it "includes all specified options" do
        adapter.install("jobs" => 4, "path" => "vendor/bundle")

        expect(Appraisal::Command).to have_received(:new).with(
          ["ore", "install", "-workers=4", "-vendor=/home/test/vendor/bundle", "-lockfile=#{gemfile_path}.lock"],
          :gemfile => gemfile_path,
          :skip_bundle_exec => true,
        )
      end
    end
  end

  describe "#update", :ore do
    before do
      allow(adapter).to receive(:system).with("which ore > /dev/null 2>&1").and_return(true)
      allow(Bundler).to receive(:with_original_env).and_yield
      allow(Dir).to receive(:chdir).and_yield
      allow(Appraisal::Command).to receive(:new).and_return(double(:run => true))
      allow(adapter).to receive(:puts)
    end

    it "runs ore update command with no gems" do
      adapter.update

      expect(Appraisal::Command).to have_received(:new).with(
        ["ore", "update", "-gemfile", gemfile_path],
        :gemfile => gemfile_path,
        :skip_bundle_exec => true,
      )
    end

    it "runs ore update command with specific gems" do
      adapter.update(["rack", "rails"])

      expect(Appraisal::Command).to have_received(:new).with(
        ["ore", "update", "-gemfile", gemfile_path, "rack", "rails"],
        :gemfile => gemfile_path,
        :skip_bundle_exec => true,
      )
    end
  end

  context "when ore is not available" do
    before do
      allow(adapter).to receive(:system).with("which ore > /dev/null 2>&1").and_return(false)
    end

    describe "#install" do
      it "raises OreNotAvailableError" do
        expect { adapter.install }.to raise_error(Appraisal::OreNotAvailableError)
      end
    end

    describe "#update" do
      it "raises OreNotAvailableError" do
        expect { adapter.update }.to raise_error(Appraisal::OreNotAvailableError)
      end
    end
  end
end
