require 'guard/minitest/utils'

if ::Guard::Minitest::Utils.minitest_version_gte_5_0_4?
  require 'guard/minitest/reporter'
else
  require 'guard/minitest/reporters/old_reporter'
end

module Minitest
  def self.plugin_guard_minitest_options(_opts, _options) # :nodoc:
  end

  def self.plugin_guard_minitest_init(_options) # :nodoc:
    reporter << ::Guard::Minitest::Reporter.new
  end
end
