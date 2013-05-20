# encoding: utf-8
Kernel.load File.expand_path('../lib/guard/minitest/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'guard-minitest'
  s.version     = Guard::MinitestVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'Guard gem for MiniTest framework'
  s.description = 'Guard::Minitest automatically run your tests with MiniTest framework (much like autotest)'
  s.author      = 'Yann Lugrin'
  s.email       = 'yann.lugrin@sans-savoir.net'
  s.homepage    = 'https://github.com/guard/guard-minitest'

  s.add_runtime_dependency 'guard',    '>= 1.8'
  s.add_runtime_dependency 'minitest', '>= 2.1'

  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'mocha',   '~> 0.14'

  s.files        = Dir.glob('{lib}/**/*') + %w[CHANGELOG.md LICENSE README.md]
  s.require_path = 'lib'
end
