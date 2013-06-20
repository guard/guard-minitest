minitest_version = ::MiniTest::Unit::VERSION.split(/\./)
if minitest_version[0].to_i >= 5 && (minitest_version[1].to_i > 0 || minitest_version[2].to_i >= 4)
  require 'guard/minitest/reporter'
else
  require 'guard/minitest/reporters/old_reporter'
end

module Minitest
  def self.plugin_guard_minitest_options(opts, options) # :nodoc:
  end

  def self.plugin_guard_minitest_init(options) # :nodoc:
    self.reporter << ::Guard::Minitest::Reporter.new(File.open('/dev/null', 'w'))
  end
end
