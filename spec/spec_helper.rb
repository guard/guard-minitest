require 'coveralls'
Coveralls.wear!

require 'minitest/autorun'
require 'mocha/setup'

require 'guard/minitest'
ENV["GUARD_ENV"] = 'test'

class Minitest::Spec < Minitest::Test

  before(:each) do
    @real_minitest_version = Minitest::VERSION.dup

    # Stub all UI methods, so no visible output appears for the UI class
    ::Guard::UI.stubs(:info)
    ::Guard::UI.stubs(:warning)
    ::Guard::UI.stubs(:error)
    ::Guard::UI.stubs(:debug)
    ::Guard::UI.stubs(:deprecation)
  end

  after(:each) do
    @_memoized = nil

    if Minitest.const_defined?(:VERSION)
      Minitest::VERSION.replace(@real_minitest_version)
    else
      Minitest.send(:const_set, :VERSION, @real_minitest_version)
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
