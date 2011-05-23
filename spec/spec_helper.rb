# encoding: utf-8
require 'minitest/unit'
require 'minitest/spec'
require 'mocha'

require 'guard/minitest'

class MiniTest::Spec < MiniTest::Unit::TestCase

  before(:each) do
    ENV['GUARD_ENV'] = 'test'
  end

  after(:each) do
    ENV['GUARD_ENV'] = nil
  end

  def subject; end

  def self.subject(&block)
    define_method :subject, &block
  end

  def fixtures_path
    @fixtures_path ||= Pathname.new(File.expand_path('../fixtures/', __FILE__))
  end

end
