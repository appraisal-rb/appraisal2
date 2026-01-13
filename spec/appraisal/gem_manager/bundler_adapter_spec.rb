# frozen_string_literal: true

require "appraisal/gem_manager/bundler_adapter"

RSpec.describe Appraisal::GemManager::BundlerAdapter do
  let(:gemfile_path) { "/home/test/test directory/gemfile" }
  let(:project_root) { Pathname.new("/home/test") }
  subject(:adapter) { described_class.new(gemfile_path, project_root) }

  describe "#name" do
    it "returns 'bundler'" do
      expect(adapter.name).to eq("bundler")
    end
  end

  describe "#available?" do
    it "returns true (bundler is always available)" do
      expect(adapter.available?).to be true
    end
  end

  describe "#validate_availability!" do
    it "does not raise an error" do
      expect { adapter.validate_availability! }.not_to raise_error
    end
  end

  describe "#install" do
    before do
      allow(Appraisal::Command).to receive(:new).and_return(double(:run => true))
      allow(Bundler.settings).to receive(:[]).with(:path).and_return(nil)
    end

    it "runs bundle check and install commands" do
      adapter.install

      expect(Appraisal::Command).to have_received(:new).with(
        "bundle check --gemfile='#{gemfile_path}' || bundle install --gemfile='#{gemfile_path}'"
      )
    end

    context "with jobs option" do
      context "when bundler supports parallel installation" do
        before do
          stub_const("Bundler::VERSION", "1.4.0")
        end

        it "includes --jobs flag" do
          adapter.install("jobs" => 4)

          expect(Appraisal::Command).to have_received(:new).with(
            "bundle check --gemfile='#{gemfile_path}' || bundle install --gemfile='#{gemfile_path}' --jobs=4"
          )
        end
      end

      context "when bundler does not support parallel installation" do
        include SilentStream

        before do
          stub_const("Bundler::VERSION", "1.3.0")
        end

        it "does not include --jobs flag and warns" do
          warning = capture(:stderr) do
            adapter.install("jobs" => 4)
          end

          expect(Appraisal::Command).to have_received(:new).with(
            "bundle check --gemfile='#{gemfile_path}' || bundle install --gemfile='#{gemfile_path}'"
          )
          expect(warning).to include("Please upgrade Bundler")
        end
      end

      it "does not include --jobs flag when jobs is 1" do
        adapter.install("jobs" => 1)

        expect(Appraisal::Command).to have_received(:new).with(
          "bundle check --gemfile='#{gemfile_path}' || bundle install --gemfile='#{gemfile_path}'"
        )
      end
    end

    context "with retry option" do
      it "includes --retry flag" do
        adapter.install("retry" => 3)

        expect(Appraisal::Command).to have_received(:new).with(
          "bundle check --gemfile='#{gemfile_path}' || bundle install --gemfile='#{gemfile_path}' --retry 3"
        )
      end
    end

    context "with path option" do
      it "includes --path flag with resolved path" do
        adapter.install("path" => "vendor/bundle")

        expect(Appraisal::Command).to have_received(:new).with(
          "bundle check --gemfile='#{gemfile_path}' || bundle install --gemfile='#{gemfile_path}' --path /home/test/vendor/bundle"
        )
      end
    end

    context "with without option" do
      it "skips check command when without is specified" do
        adapter.install("without" => "development test")

        expect(Appraisal::Command).to have_received(:new).with(
          "bundle install --gemfile='#{gemfile_path}' --without development test"
        )
      end
    end

    context "when Bundler.settings[:path] is set" do
      before do
        allow(Bundler.settings).to receive(:[]).with(:path).and_return("vendor/bundle")
      end

      it "passes BUNDLE_DISABLE_SHARED_GEMS env to Command" do
        adapter.install

        expect(Appraisal::Command).to have_received(:new).with(
          "bundle check --gemfile='#{gemfile_path}' || bundle install --gemfile='#{gemfile_path}'",
          :env => {"BUNDLE_DISABLE_SHARED_GEMS" => "1"}
        )
      end
    end
  end

  describe "#update" do
    before do
      allow(Appraisal::Command).to receive(:new).and_return(double(:run => true))
    end

    it "runs bundle update without gems" do
      adapter.update

      expect(Appraisal::Command).to have_received(:new).with(
        ["bundle", "update"],
        :gemfile => gemfile_path
      )
    end

    it "runs bundle update with specific gems" do
      adapter.update(["rails", "rspec"])

      expect(Appraisal::Command).to have_received(:new).with(
        ["bundle", "update", "rails", "rspec"],
        :gemfile => gemfile_path
      )
    end
  end
end
