# frozen_string_literal: true

# NOTE: ore-light resolves gems from rubygems.org (not local gems),
# so we use real gems in these tests rather than the dummy test gems.
RSpec.describe "CLI with ore", "appraisal install --gem-manager=ore", :ore do
  it "installs the dependencies using ore" do
    build_appraisal_file <<-APPRAISAL.strip_heredoc.rstrip
      appraise 'rack_1' do
        gem 'rack', '~> 2.2.0'
      end
    APPRAISAL

    output = run "appraisal install --gem-manager=ore"

    expect(output).to include("ore lock")
    expect(output).to include("ore install")
    expect(file("gemfiles/rack_1.gemfile.lock")).to be_exists
  end

  context "with jobs option" do
    it "passes -workers flag to ore" do
      build_appraisal_file <<-APPRAISAL.strip_heredoc.rstrip
        appraise 'rack_workers' do
          gem 'rack', '~> 2.2.0'
        end
      APPRAISAL

      output = run "appraisal install --gem-manager=ore --jobs=2"

      expect(output).to include("ore install")
      expect(output).to include("-workers=2")
    end
  end

  context "with path option" do
    it "passes -vendor flag to ore" do
      build_appraisal_file <<-APPRAISAL.strip_heredoc.rstrip
        appraise 'rack_vendor' do
          gem 'rack', '~> 2.2.0'
        end
      APPRAISAL

      output = run "appraisal install --gem-manager=ore --path=vendor/gems"

      expect(output).to include("ore install")
      expect(output).to include("-vendor=")
      expect(output).to include("vendor/gems")
    end
  end

  context "with without option" do
    it "passes -without flag to ore with comma-separated groups" do
      build_appraisal_file <<-APPRAISAL.strip_heredoc.rstrip
        appraise 'rack_without' do
          gem 'rack', '~> 2.2.0'
        end
      APPRAISAL

      output = run "appraisal install --gem-manager=ore --without='development test'"

      expect(output).to include("ore install")
      expect(output).to include("-without=development,test")
    end
  end
end
