require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new('features') do |t|
  t.rcov = ENV['RCOV']
end

Cucumber::Rake::Task.new('pretty') do |t|
  t.cucumber_opts = %w{--format pretty}
end
