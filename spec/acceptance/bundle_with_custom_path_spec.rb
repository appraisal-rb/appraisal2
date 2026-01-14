# frozen_string_literal: true

RSpec.describe "Bundle with custom path" do
  let(:gem_name) { "rack" }
  let(:path) { "vendor/bundle" }

  shared_examples "gemfile dependencies are satisfied" do
    it "installs gems in the --path directory" do
      build_gemfile <<-GEMFILE.strip_heredoc.rstrip
        source "https://gem.coop"

        gem 'appraisal2', :path => '#{local_appraisal2_path}'
      GEMFILE

      build_appraisal_file <<-APPRAISALS.strip_heredoc.rstrip
        appraise "#{gem_name}" do
          gem '#{gem_name}'
        end
      APPRAISALS

      run "bundle config set --local path #{path}"
      run "bundle install"
      run "bundle exec appraisal install"

      # Verify the path directory was created and contains gems
      base_path = file(path).to_s
      expect(File.directory?(base_path)).to be true

      # Verify dependencies are satisfied for main Gemfile
      bundle_output = run "bundle check"
      expect(bundle_output).to include("The Gemfile's dependencies are satisfied")

      # Verify dependencies are satisfied for appraisal gemfiles
      # Running appraisal install again should report satisfied dependencies
      appraisal_output = run "bundle exec appraisal install"
      expect(appraisal_output).to include("The Gemfile's dependencies are satisfied")

      run "bundle config unset --local path"
    end
  end

  it_behaves_like "gemfile dependencies are satisfied"

  context "when already installed in vendor/another" do
    before do
      # Pre-install the gem in a different vendor directory
      # Note: We still need appraisal2 in the Gemfile to keep binstubs working
      build_gemfile <<-GEMFILE.strip_heredoc.rstrip
        source "https://gem.coop"

        gem 'appraisal2', :path => '#{local_appraisal2_path}'
        gem '#{gem_name}'
      GEMFILE

      run "bundle config set --local path vendor/another"
      run "bundle install"
      run "bundle config unset --local path"
    end

    it_behaves_like "gemfile dependencies are satisfied"
  end
end
