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

require 'rbconfig'
namespace(:test) do
  if RbConfig::CONFIG['host_os'] =~ /mswin|mingw/i
    desc "Run all specs on multiple ruby versions (requires pik)"
    task(:portability) do
      puts 'minitest can\'t be tested on MS Windows for now'
    end
  else
    desc "Run all specs on multiple ruby versions (requires rvm)"
    task(:portability) do
      travis_config_file = File.expand_path("../.travis.yml", __FILE__)
      begin
        travis_options ||= YAML::load_file(travis_config_file)
      rescue => ex
        puts "Travis config file '#{travis_config_file}' could not be found: #{ex.message}"
        return
      end

      travis_options['rvm'].each do |version|
        system <<-BASH
          bash -c 'source ~/.rvm/scripts/rvm;
                   rvm #{version};
                   ruby_version_string_size=`ruby -v | wc -m`
                   echo;
                   for ((c=1; c<$ruby_version_string_size+21; c++)); do echo -n "="; done
                   echo;
                   echo "minitest version 1 - `ruby -v`";
                   for ((c=1; c<$ruby_version_string_size+21; c++)); do echo -n "="; done
                   echo;
                   BUNDLE_GEMFILE=./gemfiles/minitest-1.7 bundle install;
                   BUNDLE_GEMFILE=./gemfiles/minitest-1.7 bundle exec rake test 2>&1'
        BASH
        if version =~ /^1\.9/
          system <<-BASH
            bash -c 'source ~/.rvm/scripts/rvm;
                     rvm #{version};
                     ruby_version_string_size=`ruby -v | wc -m`
                     echo;
                     for ((c=1; c<$ruby_version_string_size+21; c++)); do echo -n "="; done
                     echo;
                     echo "minitest version 2 - `ruby -v`";
                     for ((c=1; c<$ruby_version_string_size+21; c++)); do echo -n "="; done
                     echo;
                     BUNDLE_GEMFILE=./gemfiles/minitest-2.1 bundle install;
                     BUNDLE_GEMFILE=./gemfiles/minitest-2.1 bundle exec rake test 2>&1'
          BASH
        end
      end
    end
  end
end
