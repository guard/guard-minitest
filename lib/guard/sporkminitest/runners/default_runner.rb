# encoding: utf-8
require 'minitest/unit'

if MiniTest::Unit::VERSION =~ /^1/
  load File.expand_path('../version_1_runner.rb', __FILE__)
else
  load File.expand_path('../version_2_runner.rb', __FILE__)
end
