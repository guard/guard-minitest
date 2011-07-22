# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'guard/minitest/version'

Gem::Specification.new do |s|
  s.name        = 'guard-minitest'
  s.version     = Guard::MinitestVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Yann Lugrin']
  s.email       = ['yann.lugrin@sans-savoir.net']
  s.homepage    = 'http://rubygems.org/gems/guard-minitest'
  s.summary     = 'Guard gem for MiniTest framework'
  s.description = 'Guard::Minitest automatically run your tests with MiniTest framework (much like autotest)'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'guard-minitest'

  s.add_dependency 'guard', '~> 0.4'

  # Use this environment variable only for testing
  if ENV["minitest_version"] =~ /^1/
    s.add_development_dependency 'minitest',  '~> 1.7.2'
  elsif ENV["minitest_version"] =~ /^2\.0/
    s.add_development_dependency 'minitest',  '~> 2.0.0'
  else
    s.add_development_dependency 'minitest',  '~> 2.1.0'
  end
  s.add_development_dependency 'bundler',   '>= 1.0.2'
  s.add_development_dependency 'mocha',     '>= 0.9.8'

  s.files        = Dir.glob('{lib}/**/*') + %w[LICENSE README.rdoc]
  s.require_path = 'lib'

  s.rdoc_options = ["--charset=UTF-8", "--main=README.rdoc", "--exclude='(lib|test|spec)|(Gem|Guard|Rake)file'"]
end
