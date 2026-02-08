# frozen_string_literal: true

RSpec.describe "CLI", ".install with named appraisal" do
  context "when targeting a specific appraisal" do
    before do
      build_appraisal_file <<-APPRAISAL.strip_heredoc.rstrip
        appraise 'rails-6' do
          gem 'dummy', '1.0.0'
        end

        appraise 'rails-7' do
          gem 'dummy', '1.1.0'
        end
      APPRAISAL
    end

    it "installs dependencies for only the named appraisal" do
      run "appraisal rails-7 install"

      expect(file("gemfiles/rails_7.gemfile.lock")).to be_exists
      expect(content_of("gemfiles/rails_7.gemfile.lock")).to include("dummy (1.1.0)")
    end

    it "accepts --gem-manager option" do
      output = run "appraisal rails-7 install --gem-manager=bundler"

      expect(output).to include("bundle install")
      expect(output).to include("gemfiles/rails_7.gemfile")
      expect(file("gemfiles/rails_7.gemfile.lock")).to be_exists
    end

    it "accepts -g shorthand for gem-manager" do
      output = run "appraisal rails-7 install -g bundler"

      expect(output).to include("bundle install")
      expect(output).to include("gemfiles/rails_7.gemfile")
      expect(file("gemfiles/rails_7.gemfile.lock")).to be_exists
    end

    it "accepts --jobs option with named appraisal", :parallel do
      output = run "appraisal rails-7 install --jobs=2"

      expect(output).to include("bundle install")
      expect(output).to include("gemfiles/rails_7.gemfile")
      expect(output).to match(/--jobs[\\= ]2/)
      expect(file("gemfiles/rails_7.gemfile.lock")).to be_exists
    end

    it "accepts multiple options with named appraisal", :parallel do
      output = run "appraisal rails-7 install --gem-manager=bundler --jobs=2"

      expect(output).to include("bundle install")
      expect(output).to include("gemfiles/rails_7.gemfile")
      expect(output).to match(/--jobs[\\= ]2/)
      expect(file("gemfiles/rails_7.gemfile.lock")).to be_exists
    end

    it "does not install other appraisals" do
      run "appraisal rails-7 install"

      expect(file("gemfiles/rails_7.gemfile.lock")).to be_exists
      expect(file("gemfiles/rails_6.gemfile.lock")).not_to be_exists
    end
  end

  context "with ore gem manager", :ore do
    before do
      build_appraisal_file <<-APPRAISAL.strip_heredoc.rstrip
        appraise 'rails-7' do
          gem 'rack', '~> 2.2.0'
        end
      APPRAISAL
    end

    it "installs using ore when --gem-manager=ore is specified" do
      skip "ore not available" unless ore_available?

      output = run "appraisal rails-7 install --gem-manager=ore"

      expect(output).to include("ore install")
      expect(file("gemfiles/rails_7.gemfile.lock")).to be_exists
    end

    it "installs using ore with short flag -g ore" do
      skip "ore not available" unless ore_available?

      output = run "appraisal rails-7 install -g ore"

      expect(output).to include("ore install")
      expect(file("gemfiles/rails_7.gemfile.lock")).to be_exists
    end
  end
end
