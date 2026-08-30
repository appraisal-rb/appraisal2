# frozen_string_literal: true

RSpec.describe DependencyHelpers do
  include described_class

  it "restores GEM_HOME when a fixture gem already exists" do
    original_gem_home = ENV["GEM_HOME"]
    ENV["GEM_HOME"] = "/original/gem/home"

    begin
      allow(File).to receive(:exist?).with(File.join(TMP_GEM_ROOT, "gems", "dummy-1.0.0")).and_return(true)

      build_gem("dummy")

      expect(ENV["GEM_HOME"]).to eq("/original/gem/home")
    ensure
      ENV["GEM_HOME"] = original_gem_home
    end
  end

  it "restores GEM_HOME when a fixture git repository already exists" do
    original_gem_home = ENV["GEM_HOME"]
    ENV["GEM_HOME"] = "/original/gem/home"

    begin
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with(File.join(TMP_GEM_ROOT, "gems", "dummy-1.0.0")).and_return(true)
      allow(File).to receive(:exist?).with(File.join(TMP_GEM_BUILD, "dummy", ".git")).and_return(true)

      build_git_gem("dummy")

      expect(ENV["GEM_HOME"]).to eq("/original/gem/home")
    ensure
      ENV["GEM_HOME"] = original_gem_home
    end
  end
end
