# frozen_string_literal: true

require "anonymous_loader"
RSpec.describe Appraisal::Version do
  it "executes the version file for coverage without redefining constants" do
    path = File.expand_path("../../lib/appraisal/version.rb", __dir__)
    anonymous_namespace = AnonymousLoader.load(:files => path)

    expect(anonymous_namespace::Appraisal::Version::VERSION).to eq(described_class::VERSION)
  end
end
