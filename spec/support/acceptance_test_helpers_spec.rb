# frozen_string_literal: true

RSpec.describe AcceptanceTestHelpers do
  include described_class

  describe "#restore_environment_variables" do
    it "restores GEM_HOME after fixture gem setup changes it" do
      stub_env("GEM_HOME" => "/original/gem/home")

      save_environment_variables
      ENV["GEM_HOME"] = TMP_GEM_ROOT
      restore_environment_variables

      expect(ENV["GEM_HOME"]).to eq("/original/gem/home")
    end
  end
end
