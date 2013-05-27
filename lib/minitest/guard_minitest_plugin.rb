require 'guard/minitest/reporter'

module Minitest
  def self.plugin_guard_minitest_options(opts, options) # :nodoc:
  end

  def self.plugin_guard_minitest_init(options) # :nodoc:
    self.reporter << ::Guard::Minitest::Reporter.new(File.open('/dev/null', 'w'))
  end
end
