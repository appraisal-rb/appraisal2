# frozen_string_literal: true

RSpec.shared_context "with bundler gem manager mocked" do
  let(:bundler_adapter) { instance_double(Appraisal::GemManager::BundlerAdapter) }

  before do
    allow(Appraisal::GemManager::Factory).to receive(:create).with(anything, anything, hash_including(:manager => "bundler")).and_return(bundler_adapter)
    allow(Appraisal::GemManager::Factory).to receive(:create).with(anything, anything, hash_including(:manager => nil)).and_return(bundler_adapter)
    allow(bundler_adapter).to receive(:install)
    allow(bundler_adapter).to receive(:update)
  end
end
