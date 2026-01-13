#### IMPORTANT ##############################################################
# Gemfile is for local development, not CI,                                 #
#   except for the Kitchen Sink workflow (deps_locked.yml).                     #
# Dependencies from gemspecs (including development dependencies) are used, #
#   with additions (managed by appraisal2) in gemfiles/*.gemfile            #
####################################################### IMPORTANT ###########

# frozen_string_literal: true

source "https://gem.coop"

git_source(:codeberg) { |repo_name| "https://codeberg.org/#{repo_name}" }
git_source(:gitlab) { |repo_name| "https://gitlab.com/#{repo_name}" }

# Specify your gem's dependencies in the appraisal2.gemspec
gemspec

eval_gemfile "gemfiles/modular/debug.gemfile"
eval_gemfile "gemfiles/modular/coverage.gemfile"
eval_gemfile "gemfiles/modular/style.gemfile"
eval_gemfile "gemfiles/modular/documentation.gemfile"
eval_gemfile "gemfiles/modular/x_std_libs.gemfile"
