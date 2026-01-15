# encoding: utf-8

$:.push File.expand_path('../lib', __FILE__)
require 'guard/minitest/version'

Gem::Specification.new do |s|
  s.name        = 'guard-minitest'
  s.version     = Guard::MinitestVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'
  s.authors     = ['Yann Lugrin', 'Rémy Coutable']
  s.email       = ['remy@rymai.me']
  s.homepage    = 'https://rubygems.org/gems/guard-minitest'
  s.summary     = 'Guard plugin for the Minitest framework'
  s.description = 'Guard::Minitest automatically run your tests with Minitest framework (much like autotest)'

  s.required_ruby_version = '>= 1.9.2'

  s.add_runtime_dependency 'guard-compat', '~> 1.2'
  s.add_runtime_dependency 'minitest', '>= 3.0'

  s.add_development_dependency 'guard-rubocop'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '>= 3.1.0'

  s.files        = `git ls-files -z lib`.split("\x0") + %w[CHANGELOG.md LICENSE README.md]
  s.require_path = 'lib'
end
