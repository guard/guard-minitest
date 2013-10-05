require 'bundler'
Bundler::GemHelper.install_tasks

desc 'Run all specs'
task :spec do
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/spec'))

  Dir['spec/**/*_spec.rb'].each { |f| require f }
end

task default: :spec
