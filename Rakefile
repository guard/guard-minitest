require 'bundler'
Bundler::GemHelper.install_tasks

require 'minitest/unit'

desc 'Run all tests'
task :test do
  ENV['QUIET'] ||= 'true'

  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/test'))

  MiniTest::Unit.autorun

  test_files = Dir['test/**/*_spec.rb'] + Dir['test/**/test_*.rb']
  test_files.each { |f| require f }
end

task :default => :test

namespace(:test) do
  desc "Run all tests on multiple ruby versions (requires rvm)"
  task(:portability) do
    %w[1.8.7 1.9.2].each do |version|
      system <<-BASH
        bash -c 'source ~/.rvm/scripts/rvm;
                 rvm #{version};
                 echo "--------- version #{version} ----------\n";
                 bundle install;
                 rake test'
      BASH
    end
  end
end