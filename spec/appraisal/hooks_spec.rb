# frozen_string_literal: true

require "appraisal/hooks"

RSpec.describe Appraisal::Hooks do
  after do
    described_class.reset!
  end

  it "requires a block for after_write_gemfile hooks" do
    expect { described_class.after_write_gemfile }.to raise_error(
      ArgumentError,
      "after_write_gemfile requires a block"
    )
  end

  it "runs registered after_write_gemfile hooks" do
    calls = []
    appraisal = instance_double(Appraisal::Appraisal)

    Appraisal.after_write_gemfile do |hook_appraisal, path|
      calls << [hook_appraisal, path]
    end

    described_class.run_after_write_gemfile(appraisal, "gemfiles/current.gemfile")

    expect(calls).to eq([[appraisal, "gemfiles/current.gemfile"]])
  end

  it "can reset registered hooks" do
    calls = []
    Appraisal.after_write_gemfile { calls << true }

    described_class.reset!
    described_class.run_after_write_gemfile(nil, "gemfiles/current.gemfile")

    expect(calls).to be_empty
  end
end
