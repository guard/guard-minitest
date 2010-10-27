# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest do
  subject { Guard::Minitest }

  before(:each) do
    @runner = Guard::Minitest::Runner.new
    Guard::Minitest::Runner.stubs(:new).returns(@runner)
    @guard = subject.new
  end

  describe 'start' do

    it 'should initialize runner with options' do
      Guard::Minitest::Runner.expects(:new).with({})
      @guard.start
    end

  end

  describe 'run_all' do

    before(:each) do
      @guard.start
    end

    it 'should run all tests' do
      Guard::Minitest::Inspector.stubs(:clean).with(['test', 'spec']).returns(['test/guard/minitest/test_inspector.rb', 'test/guard/test_minitest.rb'])
      @runner.expects(:run).with(['test/guard/minitest/test_inspector.rb', 'test/guard/test_minitest.rb'], {:message => 'Running all tests'})
      @guard.run_all
    end

  end

  describe 'run_on_change' do

    before(:each) do
      @guard.start
    end

    it 'should run minitest in paths' do
      @runner.expects(:run).with(['test/guard/minitest/test_inspector.rb'])
      @guard.run_on_change(['test/guard/minitest/test_inspector.rb'])
    end

  end
end
