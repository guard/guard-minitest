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
  s.homepage    = 'https://github.com/guard/guard-minitest'
  s.summary     = 'Guard gem for the Minitest framework'
  s.description = 'Guard::Minitest automatically run your tests with Minitest framework (much like autotest)'

  s.add_runtime_dependency 'guard',    '~> 2.0'
  s.add_runtime_dependency 'minitest', '>= 2.1'

  s.add_development_dependency 'bundler'

  s.files        = Dir.glob('{lib}/**/*') + %w[CHANGELOG.md LICENSE README.md]
  s.require_path = 'lib'
end
