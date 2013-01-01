# encoding: utf-8
$:.unshift './lib'
require 'guard/sporkminitest/version'

Gem::Specification.new do |gem|
  gem.name        = 'guard-sporkminitest'
  gem.version     = Guard::SporkMinitest::VERSION
  gem.authors     = ['Yann Lugrin', '☈king']
  gem.email       = ['rking-guard-sporkminitest@sharpsaw.org']
  gem.homepage    = 'https://github.com/rking/guard-minitest'
  gem.description = gem.summary = 'Guard test files for Spork-owned MiniTest'
  gem.files       = `git ls-files`.split($/)
  gem.executables = gem.files.grep(%r{^bin/}).map{|f| File.basename f}
  gem.test_files  = gem.files.grep %r{^ test|spec|features/}
  gem.require_path = 'lib'

  # TODO doc these a bit
  %w(
    guard
    guard-spork
    spork-minitest
    rb-inotify
    rb-fsevent
  ).each{|dep| gem.add_dependency dep }

  %w(
    rake
    minitest
    bundler
    mocha
  ).each{|dep| gem.add_development_dependency dep}

  gem.rdoc_options = ["--charset=UTF-8", "--main=README.rdoc", "--exclude='(lib|test|spec)|(Gem|Guard|Rake)file'"]
end
