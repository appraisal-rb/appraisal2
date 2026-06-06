# frozen_string_literal: true

require "appraisal/hooks"

RSpec.describe Appraisal::Hooks do
  after do
    described_class.reset!
  end

  it "requires a block for gemfile transforms" do
    expect { described_class.transform_gemfile }.to raise_error(
      ArgumentError,
      "transform_gemfile requires a block"
    )
  end

  it "runs registered gemfile transforms with content and context" do
    appraisal = instance_double(Appraisal::Appraisal)

    Appraisal.transform_gemfile do |content, context|
      expect(context.appraisal).to eq(appraisal)
      expect(context.path).to eq("gemfiles/current.gemfile")
      "#{content}# transformed\n"
    end

    content = described_class.run_transform_gemfile(appraisal, "gemfiles/current.gemfile", "source\n")

    expect(content).to eq("source\n# transformed\n")
  end

  it "runs single-argument transforms with content" do
    appraisal = instance_double(Appraisal::Appraisal)

    Appraisal.transform_gemfile { |content| "#{content}# transformed\n" }

    content = described_class.run_transform_gemfile(appraisal, "gemfiles/current.gemfile", "source\n")

    expect(content).to eq("source\n# transformed\n")
  end

  it "can reset registered hooks" do
    Appraisal.transform_gemfile { |content| "#{content}# transformed\n" }

    described_class.reset!
    content = described_class.run_transform_gemfile(nil, "gemfiles/current.gemfile", "source\n")

    expect(content).to eq("source\n")
  end
end
