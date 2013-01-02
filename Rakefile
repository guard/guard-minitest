require 'bundler'
Bundler::GemHelper.install_tasks

require 'minitest/unit'

task :default => :test

desc 'Run all tests'
task :test do
  ENV['QUIET'] ||= 'true'

  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/spec'))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

  MiniTest::Unit.autorun

  test_files = Dir['spec/**/*_spec.rb']
  test_files.each { |f| require f }
end
