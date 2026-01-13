# frozen_string_literal: true

RSpec.describe "Bundle without group" do
  it "config set --local without group is honored by Bundler" do
    reason = "config set --local without group support seems broken, see: https://github.com/rubygems/rubygems/issues/8518"
    # The seeming randomness of the below behavior may be due to the many layers of bundler here.
    # The spec suite itself runs in bundler, and then we further execute bundler within tests.
    # Somehow this spec passes on truffleruby *only*!!
    # For some reason it is not working on Ruby v3 or v4
    pending_for(:engine => "ruby", :versions => %w(3.0.7 3.1.7 3.2.9 3.3.9 3.4.8 4.0.0), :reason => reason)
    # And only some versions of Ruby v2
    pending_for(:engine => "ruby", :versions => %w(2.3.8 2.4.10 2.5.9), :reason => reason)
    pending_for(:engine => "jruby", :reason => reason)
    build_gems %w[pancake orange_juice waffle coffee sausage soda]

    build_gemfile <<-GEMFILE.strip_heredoc.rstrip
      source "https://gem.coop"

      gem "pancake"
      gem "rake", "~> 10.5", :platform => :ruby_18

      group :drinks do
        gem "orange_juice"
      end

      gem "appraisal2", :path => '#{local_appraisal2_path}'
    GEMFILE

    build_appraisal_file <<-APPRAISALS.strip_heredoc.rstrip
      appraise "breakfast" do
        gem "waffle"

        group :drinks do
          gem "coffee"
        end
      end

      appraise "lunch" do
        gem "sausage"

        group :drinks do
          gem "soda"
        end
      end
    APPRAISALS

    run "bundle install --local"
    run "bundle config set --local without 'drinks'"
    output = run "appraisal install"

    expect(output).to include("Bundle complete")
    expect(output).not_to include("orange_juice")
    expect(output).not_to include("coffee")
    expect(output).not_to include("soda")

    output = run "appraisal install"

    expect(output).to include("The Gemfile's dependencies are satisfied")
  end
end
