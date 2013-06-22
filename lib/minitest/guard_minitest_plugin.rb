require 'rubygems/requirement'

requirement = Gem::Requirement.new('>= 5.0.4')
minitest_version = Gem::Version.new(::MiniTest::Unit::VERSION)
if requirement.satisfied_by?(minitest_version)
  require 'guard/minitest/reporter'
else
  require 'guard/minitest/reporters/old_reporter'
end

module Minitest
  def self.plugin_guard_minitest_options(opts, options) # :nodoc:
  end

  def self.plugin_guard_minitest_init(options) # :nodoc:
    self.reporter << ::Guard::Minitest::Reporter.new
  end
end
