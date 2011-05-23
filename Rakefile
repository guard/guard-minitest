require 'bundler'
Bundler::GemHelper.install_tasks

require 'minitest/unit'

desc 'Run all tests'
task :test do
  ENV['QUIET'] ||= 'true'

  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/spec'))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

  MiniTest::Unit.autorun

  test_files = Dir['spec/**/*_spec.rb']
  test_files.each { |f| require f }
end

task :default => :test

namespace(:test) do
  desc "Run all tests on multiple ruby versions (requires rvm)"
  task(:portability) do
    %w[1.8.6 1.8.7 1.9.2].each do |version|
      system <<-BASH
        bash -c 'source ~/.rvm/scripts/rvm;
                 rvm #{version};
                 echo "--------- ruby version #{version} - minitest version 1 ----------\n";
                 minitest_version=1 bundle install;
                 minitest_version=1 bundle exec rake test'
      BASH
      if version !~ /^1\.8/
        system <<-BASH
          bash -c 'source ~/.rvm/scripts/rvm;
                   rvm #{version};
                   echo "--------- ruby version #{version} - minitest version 2 ----------\n";
                   minitest_version=2 bundle install;
                   minitest_version=2 bundle exec rake test'
        BASH
      end
    end
  end
end
