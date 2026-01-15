require 'rspec/core/rake_task'
require 'bundler/gem_tasks'
require 'bundler/setup'

desc 'Default: Run all specs'
task default: :spec

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = (ENV['CI'] == 'true')
end
