# frozen_string_literal: true

# HOW TO UPDATE APPRAISALS:
#   BUNDLE_GEMFILE=Appraisal.root.gemfile bundle
#   BUNDLE_GEMFILE=Appraisal.root.gemfile bundle exec appraisal update
#   bundle exec rake rubocop_gradual:autocorrect
# NOTE: We do not run specs with appraisals, because that's appraisal-inception.
#       Instead, BUNDLE_GEMFILE in each CI run targets an appraisal.

# Used for HEAD (nightly) releases of ruby, truffleruby, and jruby.
# Split into discrete appraisals if one of them needs a dependency locked discretely.
appraise "dep-heads" do
  eval_gemfile "modular/runtime_heads.gemfile"
end

appraise "ruby-1-8" do
  eval_gemfile "modular/ruby_1_8.gemfile"
end

appraise "ruby-1-9" do
  eval_gemfile "modular/ruby_1_9.gemfile"
end

appraise "ruby-2-0" do
  eval_gemfile "modular/ruby_2_0.gemfile"
end

appraise "ruby-2-1" do
  eval_gemfile "modular/ruby_2_1.gemfile"
end

appraise "ruby-2-2" do
  eval_gemfile "modular/ruby_2_2.gemfile"
end

appraise "ruby-2-3" do
  eval_gemfile "modular/ruby_2_3.gemfile"
end

appraise "ruby-2-4" do
  eval_gemfile "modular/ruby_2_4.gemfile"
end

appraise "ruby-2-5" do
  eval_gemfile "modular/ruby_2_5.gemfile"
end

appraise "ruby-2-6" do
  eval_gemfile "modular/ruby_2_6.gemfile"
end

appraise "ruby-2-7" do
  eval_gemfile "modular/ruby_2_7.gemfile"
end

appraise "ruby-3-0" do
  eval_gemfile "modular/ruby_3_0.gemfile"
end

appraise "ruby-3-1" do
  eval_gemfile "modular/ruby_3_1.gemfile"
end

appraise "ruby-3-2" do
  eval_gemfile "modular/ruby_3_2.gemfile"
end

appraise "ruby-3-3" do
  eval_gemfile "modular/ruby_3_3.gemfile"
end

# Used for current releases of ruby, truffleruby, and jruby.
# Split into discrete appraisals if one of them needs a dependency locked discretely.
appraise "current" do
  eval_gemfile "modular/current.gemfile"
end

appraise "heads" do
  eval_gemfile "modular/heads.gemfile"
end

# Only run security audit on the latest version of Ruby
appraise "audit" do
  eval_gemfile "modular/audit.gemfile"
end

# Only run coverage on the latest version of Ruby
appraise "coverage" do
  eval_gemfile "modular/coverage.gemfile"
end

# Only run linter on the latest version of Ruby (but, in support of the oldest supported Ruby version)
appraise "style" do
  eval_gemfile "modular/style.gemfile"
end
