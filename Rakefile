require 'bundler'
Bundler::GemHelper.install_tasks

require 'minitest/autorun'

desc 'Run all tests'
task :test do
  ENV['QUIET'] ||= 'true'

  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/spec'))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

  if ::MiniTest::Unit::VERSION =~ /^5/
    Minitest.autorun
  else
    MiniTest::Unit.autorun
  end

  test_files = Dir['spec/**/*_spec.rb']
  test_files.each { |f| require f }
end

task :default => :test
