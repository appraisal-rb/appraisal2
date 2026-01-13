# frozen_string_literal: true

require "appraisal/gem_manager/base"

RSpec.describe Appraisal::GemManager::Base do
  subject(:base) { described_class.new(gemfile_path, project_root) }

  let(:gemfile_path) { "/path/to/gemfile" }
  let(:project_root) { Pathname.new("/path/to/project") }

  describe "#initialize" do
    it "stores gemfile_path" do
      expect(base.gemfile_path).to eq(gemfile_path)
    end

    it "stores project_root" do
      expect(base.project_root).to eq(project_root)
    end
  end

  describe "#install" do
    it "raises NotImplementedError" do
      expect { base.install }.to raise_error(
        NotImplementedError,
        "Appraisal::GemManager::Base#install must be implemented",
      )
    end
  end

  describe "#update" do
    it "raises NotImplementedError" do
      expect { base.update }.to raise_error(
        NotImplementedError,
        "Appraisal::GemManager::Base#update must be implemented",
      )
    end
  end

  describe "#name" do
    it "raises NotImplementedError" do
      expect { base.name }.to raise_error(
        NotImplementedError,
        "Appraisal::GemManager::Base#name must be implemented",
      )
    end
  end

  describe "#available?" do
    it "raises NotImplementedError" do
      expect { base.available? }.to raise_error(
        NotImplementedError,
        "Appraisal::GemManager::Base#available? must be implemented",
      )
    end
  end

  describe "#validate_availability!" do
    it "does nothing by default (for bundler compatibility)" do
      expect { base.validate_availability! }.not_to raise_error
    end
  end
end
