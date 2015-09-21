require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

APP_RAKEFILE = File.expand_path("../test_app/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

task :default => :spec