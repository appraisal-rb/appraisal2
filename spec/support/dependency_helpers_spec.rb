# frozen_string_literal: true

RSpec.describe DependencyHelpers do
  include described_class

  it "restores GEM_HOME when a fixture gem already exists" do
    stub_env("GEM_HOME" => "/original/gem/home")
    allow(File).to receive(:exist?).with(File.join(TMP_GEM_ROOT, "gems", "dummy-1.0.0")).and_return(true)

    build_gem("dummy")

    expect(ENV["GEM_HOME"]).to eq("/original/gem/home")
  end

  it "restores GEM_HOME when a fixture git repository already exists" do
    stub_env("GEM_HOME" => "/original/gem/home")
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with(File.join(TMP_GEM_ROOT, "gems", "dummy-1.0.0")).and_return(true)
    allow(File).to receive(:exist?).with(File.join(TMP_GEM_BUILD, "dummy", ".git")).and_return(true)

    build_git_gem("dummy")

    expect(ENV["GEM_HOME"]).to eq("/original/gem/home")
  end
end
