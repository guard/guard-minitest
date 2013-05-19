require 'minitest/spec'
require 'coveralls'
Coveralls.wear!

require 'mocha/setup'

require 'guard/minitest'
ENV["GUARD_ENV"] = 'test'

class MiniTest::Spec < MiniTest::Unit::TestCase

  before(:each) do
    @real_minitest_version = MiniTest::Unit::VERSION.dup
  end

  after(:each) do
    @_memoized = nil

    if MiniTest::Unit.const_defined?(:VERSION)
      MiniTest::Unit::VERSION.replace(@real_minitest_version)
    else
      MiniTest::Unit.send(:const_set, :VERSION, @real_minitest_version)
    end
  end

  def self.let(name, &block)
    define_method name do
      @_memoized ||= {}
      @_memoized.fetch(name) { |k| @_memoized[k] = instance_eval(&block) }
    end
  end

  def self.subject(&block)
    let :subject, &block
  end

  def fixtures_path
    @fixtures_path ||= Pathname.new(File.expand_path('../fixtures/', __FILE__))
  end

end
