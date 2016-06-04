require 'rubygems'

require 'cucumber/rake/task'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new(:features)

task :default => ["spec", "features"]