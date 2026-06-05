# frozen_string_literal: true

require "version_gem"
require_relative "appraisal2/version"

require "appraisal/version"
require "appraisal/task"

Appraisal::Task.new

Appraisal2::Version.class_eval do
  extend VersionGem::Basic
end
