# encoding: utf-8
require 'minitest/unit'
require 'minitest/spec'
require 'mocha'

require 'guard/minitest'


class MiniTest::Spec < MiniTest::Unit::TestCase
  def subject; end

  def self.subject(&block)
    define_inheritable_method :subject, &block
  end

  def fixtures_path
    @fixtures_path ||= Pathname.new(File.expand_path('../fixtures/', __FILE__))
  end
end
