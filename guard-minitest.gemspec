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
  s.homepage    = "https://github.com/guard/#{s.name}"
  s.summary     = 'Guard plugin for the Minitest framework'
  s.description = 'Guard::Minitest automatically run your tests with Minitest framework (much like autotest)'

  s.metadata = {
    'bug_tracker_uri'   => "#{s.homepage}/issues",
    'changelog_uri'     => "#{s.homepage}/releases",
    'source_code_uri'   => s.homepage,
  }

  s.required_ruby_version = '>= 3.2'

  s.add_runtime_dependency 'guard-compat', '~> 1.2'
  s.add_runtime_dependency 'minitest', '>= 5.0.4', '< 7.0'

  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'guard-rubocop'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '>= 3.1'

  s.files        = `git ls-files -z lib`.split("\x0") + %w[CHANGELOG.md LICENSE README.md]
  s.require_path = 'lib'
end
