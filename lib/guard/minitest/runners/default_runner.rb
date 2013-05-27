# encoding: utf-8
require 'minitest/autorun'

case MiniTest::Unit::VERSION
when /^1/
  load File.expand_path('../version_1_runner.rb', __FILE__)
when /^[2-4]/
  load File.expand_path('../version_2_runner.rb', __FILE__)
when /^5/
  # do nothing, this is handled by guard/minitest/guard_minitest_plugin.rb
end
