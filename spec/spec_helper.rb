# encoding: utf-8
require 'minitest/unit'
require 'minitest/spec'
require 'guard/minitest'

class MiniTest::Spec < MiniTest::Unit::TestCase
  def subject; end

  def self.subject(&block)
    define_inheritable_method :subject, &block
  end
end
