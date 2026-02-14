# frozen_string_literal: true

# NOTE: ore-light resolves gems from rubygems.org (not local gems),
# so we use real gems in these tests rather than the dummy test gems.
RSpec.describe "CLI with ore", ".update --gem-manager=ore", :ore do
  before do
    build_appraisal_file <<-APPRAISAL.strip_heredoc.rstrip
      appraise 'ore_update' do
        gem 'status_tag', '~> 0.2'
      end
    APPRAISAL

    # Install first using bundler (ore requires existing lockfile for update)
    run "appraisal install"
  end

  context "with no gem arguments" do
    it "updates all gems using ore" do
      output = run "appraisal update --gem-manager=ore"

      expect(output).to include("ore update")
      expect(output).to include("-gemfile")
    end
  end

  context "with a specific gem" do
    it "updates only specified gem using ore" do
      # Use raise_on_error=false since ore update may fail for various reasons
      # in test environment, but we just want to verify the command is constructed correctly
      output = run "appraisal update --gem-manager=ore rack", false

      expect(output).to include("ore update")
    end
  end
end
