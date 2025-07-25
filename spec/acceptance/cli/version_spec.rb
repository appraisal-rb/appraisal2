# frozen_string_literal: true

RSpec.describe "CLI", "appraisal version" do
  context "with version subcommand" do
    it "prints out version string" do
      output = run "appraisal version"

      expect(output).to include("Appraisal2 #{Appraisal::VERSION}")
    end
  end

  context "with -v flag" do
    it "prints out version string" do
      output = run "appraisal -v"

      expect(output).to include("Appraisal2 #{Appraisal::VERSION}")
    end
  end

  context "with --version flag" do
    it "prints out version string" do
      output = run "appraisal --version"

      expect(output).to include("Appraisal2 #{Appraisal::VERSION}")
    end
  end
end
