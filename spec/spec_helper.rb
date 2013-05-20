require 'coveralls'
Coveralls.wear!

require 'minitest/autorun'
superclass = if MiniTest::Unit::VERSION =~ /^5/
  Minitest::Test
else
  MiniTest::Unit::TestCase
end

require 'mocha/setup'

require 'guard/minitest'
ENV['GUARD_ENV'] = 'test'

class MiniTest::Spec < superclass

  before(:each) do
    @real_minitest_version = MiniTest::Unit::VERSION.dup

    # Stub all UI methods, so no visible output appears for the UI class
    ::Guard::UI.stubs(:info)
    ::Guard::UI.stubs(:warning)
    ::Guard::UI.stubs(:error)
    ::Guard::UI.stubs(:debug)
    ::Guard::UI.stubs(:deprecation)
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
