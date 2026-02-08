# frozen_string_literal: true

RSpec.shared_context "with ore gem manager mocked" do
  let(:ore_adapter) { instance_double(Appraisal::GemManager::OreAdapter) }

  before do
    allow(Appraisal::GemManager::Factory).to receive(:create).with(anything, anything, hash_including(:manager => "ore")).and_return(ore_adapter)
    allow(ore_adapter).to receive(:install)
    allow(ore_adapter).to receive(:update)
    allow(ore_adapter).to receive(:available?).and_return(true)
    allow(ore_adapter).to receive(:validate_availability!)
  end
end
