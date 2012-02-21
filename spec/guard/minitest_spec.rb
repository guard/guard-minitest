# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest do
  subject { Guard::Minitest }

  before(:each) do
    @runner = Guard::Minitest::Runner.new(:test_folders => %w[test])
    Guard::Minitest::Runner.stubs(:new).returns(@runner)
    @guard = subject.new
  end

  describe 'initialization' do

    it 'should initialize runner with options' do
      Guard::Minitest::Runner.expects(:new).with({}).returns(@runner)
      Guard::Minitest::Inspector.stubs(:new)
      subject.new
    end

    it 'should initialize inspector with options' do
      Guard::Minitest::Runner.stubs(:new).returns(@runner)
      Guard::Minitest::Inspector.expects(:new).with(@runner.test_folders, @runner.test_file_patterns)
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
      @runner.expects(:run).with(['test/guard/minitest_test.rb', 'test/guard/minitest/test_inspector.rb', 'test/guard/test_minitest.rb'], {:message => 'Running all tests'}).returns(true)
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
