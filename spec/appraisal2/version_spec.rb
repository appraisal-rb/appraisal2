# frozen_string_literal: true

require "anonymous_loader"
RSpec.describe Appraisal2::Version do
  it "executes the version file for coverage without redefining constants" do
    path = File.expand_path("../../lib/appraisal2/version.rb", __dir__)
    anonymous_namespace = AnonymousLoader.load(:files => path)

    expect(anonymous_namespace::Appraisal2::Version::VERSION).to eq(described_class::VERSION)
  end
end
