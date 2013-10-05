# Guard::Minitest
[![Gem Version](https://badge.fury.io/rb/guard-minitest.png)](http://badge.fury.io/rb/guard-minitest) [![Build Status](https://travis-ci.org/guard/guard-minitest.png?branch=master)](https://travis-ci.org/guard/guard-minitest) [![Dependency Status](https://gemnasium.com/guard/guard-minitest.png)](https://gemnasium.com/guard/guard-minitest) [![Code Climate](https://codeclimate.com/github/guard/guard-minitest.png)](https://codeclimate.com/github/guard/guard-minitest) [![Coverage Status](https://coveralls.io/repos/guard/guard-minitest/badge.png?branch=master)](https://coveralls.io/r/guard/guard-minitest)

Guard::Minitest allows to automatically & intelligently launch tests with the
[minitest framework](https://github.com/seattlerb/minitest) when files are modified.

* Compatible with minitest >= 2.1 (optimal support for 5.x).
* Tested against Ruby 1.9.3, 2.0.0, JRuby and Rubinius (1.9 mode).

## Install

Please be sure to have [Guard](http://github.com/guard/guard) installed before continue.

The simplest way to install Guard::Minitest is to use [Bundler](http://gembundler.com/).

Add Guard::Minitest to your `Gemfile`:

```ruby
group :development do
  gem 'guard-minitest'
end
```

and install it by running Bundler:

```bash
$ bundle
```

Add guard definition to your Guardfile by running the following command:

```bash
guard init minitest
```

## Ruby on Rails

Ruby on Rails lazy loads gems as needed in its test suite.
As a result Guard::Minitest may not be able to run all tests until the gem dependencies are resolved.

To solve the issue either add the missing dependencies or remove the tests.

Example:

```
Specify ruby-prof as application's dependency in Gemfile to run benchmarks.
```

Rails automatically generates a performance test stub in the `test/performance` directory which can trigger this error.
Either add `ruby-prof` to your `Gemfile` (inside the `test` group):

```ruby
group :test do
   gem 'ruby-prof'
end
```

Or remove the test (or even the `test/performance` directory if it isn't necessary.

## Usage

Please read [Guard usage doc](http://github.com/guard/guard#readme)

## Guardfile

Guard::Minitest can be really adapated to all kind of projects.
Please read [guard doc](http://github.com/guard/guard#readme) for more info about Guardfile DSL.

### Standard Guardfile when using Minitest::Unit

```ruby
guard :minitest do
  watch(%r{^test/(.*)\/?test_(.*)\.rb})
  watch(%r{^lib/(.*/)?([^/]+)\.rb})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^test/test_helper\.rb})      { 'test' }
end
```

### Standard Guardfile when using Minitest::Spec

```ruby
guard :minitest do
  watch(%r{^spec/(.*)_spec\.rb})
  watch(%r{^lib/(.+)\.rb})         { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/spec_helper\.rb}) { 'spec' }
end
```

## Options

### List of available options

```ruby
all_on_start: false               # run all tests in group on startup, default: true
cli: '--test'                     # pass arbitrary Minitest CLI arguments, default: ''
test_folders: ['tests']           # specify an array of paths that contain test files, default: %w[test spec]
include: ['lib']                  # specify an array of include paths to the command that runs the tests
test_file_patterns: %w[test_*.rb] # specify an array of patterns that test files must match in order to be run, default: %w[*_test.rb test_*.rb *_spec.rb]
spring: true                      # enable spring support, default: false
zeus: true                        # enable zeus support; default: false
drb: true                         # enable DRb support, default: false
bundler: false                    # don't use "bundle exec" to run the minitest command, default: true
rubygems: true                    # require rubygems when run the minitest command (only if bundler is disabled), default: false
```

### Options usage examples

You can change the default location of test files using the `:test_folders` option and pattern of test files using the `:test_file_patterns` option:

```ruby
guard :minitest, test_folders: 'test/unit', test_file_patterns: '*_test.rb' do
  # ...
end
```

You can pass any of the standard MiniTest CLI options using the `:cli` option:

```ruby
guard :minitest, cli: '--seed 123456 --verbose' do
  # ...
end
```

[Spring](https://github.com/jonleighton/spring) is supported (Ruby 1.9.X / Rails 3.2+ only), but you must enable it:

```ruby
guard :minitest, spring: true do
  # ...
end
```

[Zeus](https://github.com/burke/zeus) is supported, but you must enable it.
Please note that notifications support is very basic when using Zeus. The zeus client exit status is evaluated, and
a Guard `:success` or `:failed` notification is triggered. It does not include the test results though.

If you're interested in improving it, please
[open a new issue](https://github.com/guard/guard-minitest/issues/new).

If your test helper matches the test_file_patterns, it can lead to problems
as guard-minitest will submit the test helper itself to the zeus test
command when running all tests. For example, if the test helper is
called ``test/test_helper.rb`` it will match ``test_*.rb``. In this case you can
either change the test_file_patterns or rename the test helper.

```ruby
guard :minitest, zeus: true do
  # ...
end
```

[Spork / spork-testunit](https://github.com/sporkrb/spork-testunit) is supported, but you must enable it:

```ruby
guard :minitest, drb: true do
  # ...
end
```

## Development

* Documentation hosted at [RubyDoc](http://rubydoc.info/github/guard/guard-minitest/master/frames).
* Source hosted at [GitHub](https://github.com/guard/guard-minitest).

Pull requests are very welcome! Please try to follow these simple rules if applicable:

* Please create a topic branch for every separate change you make.
* Make sure your patches are well tested. All specs run by Travis CI must pass.
* Update the [README](https://github.com/guard/guard-minitest/blob/master/README.md).
* Please **do not change** the version number.

For questions please join us in our [Google group](http://groups.google.com/group/guard-dev) or on
`#guard` (irc.freenode.net).

## Maintainer

[Rémy Coutable](https://github.com/rymai) ([@rymai](http://twitter.com/rymai), [rym.ai](http://rym.ai))

## Author

[Yann Lugrin](https://github.com/yannlugrin)

## Contributors

[https://github.com/guard/guard-minitest/graphs/contributors](https://github.com/guard/guard-minitest/graphs/contributors)
