require 'bundler'
Bundler::GemHelper.install_tasks

require 'minitest/autorun'

desc 'Run all tests'
task :test do
  ENV['QUIET'] ||= 'true'

  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/spec'))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

  require 'minitest/autorun'

  test_files = Dir['spec/**/*_spec.rb']
  test_files.each { |f| require f }
end

task :default => :test
