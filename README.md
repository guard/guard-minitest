= Guard::Minitest

{<img src="https://secure.travis-ci.org/guard/guard-minitest.png" />}[http://travis-ci.org/guard/guard-minitest]

Minitest guard allows to automatically & intelligently launch tests with
{minitest framework}[http://github.com/seattlerb/minitest] when files are modified.

- Compatible with MiniTest 1.7.x & 2.x
- Tested on Ruby 1.8.6, 1.8.7 & 1.9.2.

== Install

Please be sure to have {guard}[http://github.com/guard/guard] installed before continue.

Install the gem:

    gem install guard-minitest

Add it to your Gemfile (inside test group):

    gem 'guard-minitest'

Add guard definition to your Guardfile by running this command:

    guard init minitest

== Usage

Please read {guard usage doc}[http://github.com/guard/guard#readme]

== Guardfile

Minitest guard can be really be adapated to all kind of projects.
Please read {guard doc}[http://github.com/guard/guard#readme] for more info about Guardfile DSL.

=== Standard ruby gems with Minitest::Unit

    guard 'minitest' do
      watch(%r|^test/test_(.*)\.rb|)
      watch(%r{^lib/(.*/)?([^/]+)\.rb$})  { |m| "test/#{m[1]}test_#{m[2]}.rb" }
      watch(%r|^test/test_helper\.rb|)    { "test" }
    end

=== Standard ruby gems with Minitest::Spec

    guard 'minitest' do
      watch(%r|^spec/(.*)_spec\.rb|)
      watch(%r{^lib/(.*/)?([^/]+)\.rb$})  { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
      watch(%r|^spec/spec_helper\.rb|)    { "spec" }
    end

== Options

You can force minitest seed with:

    guard 'minitest', :seed => 12345 do
      ...
    end

You can set minitest verbose mode with:

    guard 'minitest', :verbose => true do
      ...
    end

You can change the default location and pattern of minitest files:

    guard 'minitest', test_folders: 'test/unit', test_file_patterns: '*_test.rb' do
      ...
    end

You can disable desktop notification with:

    guard 'minitest', :notify => false do
      ...
    end

You can disable bundler usage to run minitest with:

    guard 'minitest', :bundler => false do
      ...
    end

You can enable rubygems usage to run minitest (only if bundler is not present or disabale) with:

    guard 'minitest', :rubygems => true do
      ...
    end

If you use {spork-testunit}[https://github.com/timcharper/spork-testunit] you can enable it with (you'll have to load it before):

    guard 'minitest', :drb => true do
      ...
    end

== Development

- Source hosted at {GitHub}[http://github.com/guard/guard-minitest]
- Report issues/Questions/Feature requests on {GitHub Issues}[http://github.com/guard/guard-minitest/issues]

Pull requests are very welcome! Make sure your patches are well tested. Please create a topic branch for every separate change
you make.

== Authors

{Yann Lugrin}[http://github.com/yannlugrin]
