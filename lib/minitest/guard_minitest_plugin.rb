require 'guard/minitest/utils'

if ::Guard::Minitest::Utils.minitest_version_gte_5_0_4?
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
