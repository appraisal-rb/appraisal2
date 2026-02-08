# frozen_string_literal: true

RSpec.describe "CLI", ".update with named appraisal" do
  context "when targeting a specific appraisal" do
    before do
      build_appraisal_file <<-APPRAISAL.strip_heredoc.rstrip
        appraise 'rails-6' do
          gem 'dummy', '~> 1.0'
        end

        appraise 'rails-7' do
          gem 'dummy', '~> 1.1'
        end
      APPRAISAL

      run "appraisal install"
    end

    it "updates dependencies for only the named appraisal" do
      output = run "appraisal rails-7 update"

      expect(output).to include("bundle update")
      expect(output).to include("gemfiles/rails_7.gemfile")
    end

    it "updates specific gems in the named appraisal" do
      output = run "appraisal rails-7 update dummy"

      expect(output).to include("bundle update dummy")
      expect(output).to include("gemfiles/rails_7.gemfile")
    end

    it "accepts --gem-manager option" do
      output = run "appraisal rails-7 update --gem-manager=bundler"

      expect(output).to include("bundle update")
      expect(output).to include("gemfiles/rails_7.gemfile")
    end

    it "accepts -g shorthand for gem-manager" do
      output = run "appraisal rails-7 update -g bundler"

      expect(output).to include("bundle update")
      expect(output).to include("gemfiles/rails_7.gemfile")
    end

    it "updates specific gems with gem manager option" do
      output = run "appraisal rails-7 update dummy --gem-manager=bundler"

      expect(output).to include("bundle update dummy")
      expect(output).to include("gemfiles/rails_7.gemfile")
    end
  end

  context "with ore gem manager", :ore do
    before do
      build_appraisal_file <<-APPRAISAL.strip_heredoc.rstrip
        appraise 'rails-7' do
          gem 'rake', '~> 13.0'
        end
      APPRAISAL

      run "appraisal install"
    end

    it "updates using ore when --gem-manager=ore is specified" do
      skip "ore not available" unless ore_available?

      output = run "appraisal rails-7 update --gem-manager=ore"

      expect(output).to include("ore update")
    end

    it "updates using ore with short flag -g ore" do
      skip "ore not available" unless ore_available?

      output = run "appraisal rails-7 update -g ore"

      expect(output).to include("ore update")
    end

    it "updates specific gems using ore" do
      skip "ore not available" unless ore_available?

      output = run "appraisal rails-7 update rake --gem-manager=ore"

      expect(output).to include("ore update -gemfile")
      expect(output).to include("gemfiles/rails_7.gemfile rake")
    end
  end
end
