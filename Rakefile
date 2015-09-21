require 'bundler'
require 'appraisal'

Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

ENV["TEST_APP"] = if ENV["APPRAISAL_INITIALIZED"]
  ENV["BUNDLE_GEMFILE"].split('/').last.split('.').first
else
  "rails_4"
end

APP_RAKEFILE = File.expand_path("../test_apps/#{ENV["TEST_APP"]}/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

task :default => :spec