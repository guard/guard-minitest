require 'guard/minitest/utils'

# Require guard unless we're using guard-minitest to test a guard plugin
require 'guard' unless Dir['guard-*.gemspec'].any?

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
