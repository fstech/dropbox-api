require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require "dropbox-api/tasks"
Dropbox::API::Tasks.install