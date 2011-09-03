# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest do
  subject { Guard::Minitest }

  before(:each) do
    @runner = runner_with_options
    @guard = subject.new
  end

  describe 'initialization' do

    it 'should initialize runner with options' do
      Guard::Minitest::Runner.expects(:new).with({})
      subject.new
    end

  end

  describe 'start' do

    it 'should return true' do
      @guard.start.must_equal true
    end

  end

  describe 'stop' do

    it 'should return true' do
      @guard.stop.must_equal true
    end

  end

  describe 'reload' do

    it 'should return true' do
      @guard.reload.must_equal true
    end

  end


  describe 'run_all' do

    it 'should run all tests' do
      Guard::Minitest::Inspector.stubs(:clean).with(['test', 'spec']).returns(['test/guard/minitest/test_inspector.rb', 'test/guard/test_minitest.rb'])
      @runner.expects(:run).with(['test/guard/minitest/test_inspector.rb', 'test/guard/test_minitest.rb'], {:message => 'Running all tests'}).returns(true)
      @guard.run_all.must_equal true
    end

  end

  describe 'run_on_change' do

    it 'should run minitest in paths' do
      @runner.expects(:run).with(['test/guard/minitest/test_inspector.rb']).returns(true)
      @guard.run_on_change(['test/guard/minitest/test_inspector.rb']).must_equal true
    end

  end
end

describe 'Custom options' do
  subject { Guard::Minitest }

  describe 'with custom :all option' do

    it 'should run all tests' do
      @folders = ['test/unit', 'test/functional']
      @runner = runner_with_options(:all => @folders)
      @guard = subject.new

      # verify: inspector should get the set folders
      Guard::Minitest::Inspector.expects(:clean).with(@folders).returns([])
      @guard.run_all
    end

  end

end

# helpers
class MiniTest::Spec < MiniTest::Unit::TestCase

  def runner_with_options(options = {})
    runner = Guard::Minitest::Runner.new(options)
    Guard::Minitest::Runner.expects(:new).returns(runner)
    runner
  end

end
