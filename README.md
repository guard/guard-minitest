Guard::Minitest [![Build Status](https://secure.travis-ci.org/guard/guard-minitest.png?branch=master)](http://travis-ci.org/guard/guard-minitest)
===============

Minitest guard allows to automatically & intelligently launch tests with
[minitest framework](http://github.com/seattlerb/minitest) when files are modified.

 * Compatible with MiniTest 1.7.x & 2.x
 * Tested on Ruby 1.8.7, 1.9.2 & 1.9.3

Install
-------

Please be sure to have [Guard](http://github.com/guard/guard) installed before continue.

Install the gem:

```bash
gem install guard-minitest
```

Add it to your Gemfile (inside test group):

```ruby
gem 'guard-minitest'
```

Add guard definition to your Guardfile by running this command:

```bash
guard init minitest
```

Usage
-----

Please read [Guard usage doc](http://github.com/guard/guard#readme)

Guardfile
---------

Minitest guard can be really be adapated to all kind of projects.
Please read {guard doc}[http://github.com/guard/guard#readme] for more info about Guardfile DSL.

### Standard ruby gems with Minitest::Unit

```ruby
guard 'minitest' do
  watch(%r|^test/test_(.*)\.rb|)
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})  { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r|^test/test_helper\.rb|)    { "test" }
end
```

### Standard ruby gems with Minitest::Spec

```ruby
guard 'minitest' do
  watch(%r|^spec/(.*)_spec\.rb|)
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})  { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r|^spec/spec_helper\.rb|)    { "spec" }
end
```

Options
-------

You can change the default location and pattern of minitest files:

```ruby
guard 'minitest', test_folders: 'test/unit', test_file_patterns: '*_test.rb' do
  # ...
end
```

If you use {spork-testunit}[https://github.com/timcharper/spork-testunit] you can enable it with (you'll have to load it before):

```ruby
guard 'minitest', :drb => true do
  # ...
end
```

### List of available options:

```ruby
:seed => 12345          # force minitest seed
:verbose => true        # set minitest verbose mode, default: false
:notify => false        # disable desktop notifications
:bundler => false            # don't use "bundle exec" to run the minitest command, default: true
:rubygems => true            # require rubygems when run the minitest command (only if bundler is disabled), default: false
```

Development
-----------

* Source hosted on [GitHub](http://github.com/guard/guard-minitest)
* Report issues/Questions/Feature requests on [GitHub Issues](http://github.com/guard/guard-minitest/issues)

Pull requests are very welcome! Make sure your patches are well tested. Please create a topic branch for every separate change
you make.

Authors
-------

{Yann Lugrin}[http://github.com/yannlugrin]

