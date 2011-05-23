# encoding: utf-8
require 'minitest/unit'
require 'minitest/spec'
require 'mocha'

require 'guard/minitest'

class MiniTest::Spec < MiniTest::Unit::TestCase

  before(:each) do
    ENV['GUARD_ENV'] = 'test'
    @real_minitest_version = MiniTest::Unit::VERSION.dup
  end

  after(:each) do
    ENV['GUARD_ENV'] = nil
    if MiniTest::Unit.const_defined?(:VERSION)
      MiniTest::Unit::VERSION.replace(@real_minitest_version)
    else
      MiniTest::Unit.send(:const_set, :VERSION, @real_minitest_version)
    end
  end

  def subject; end

  def self.subject(&block)
    define_method :subject, &block
  end

  def fixtures_path
    @fixtures_path ||= Pathname.new(File.expand_path('../fixtures/', __FILE__))
  end

end
