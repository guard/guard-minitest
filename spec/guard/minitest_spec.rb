# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest do
  subject { Guard::Minitest }

  let(:runner) { stub('runner', :test_folders => [], :test_file_patterns => []) }
  let(:inspector) { stub('inspector') }
  let(:guard) { subject.new }

  before(:each) do
    Guard::Minitest::Runner.stubs(:new).returns(runner)
    Guard::Minitest::Inspector.stubs(:new).returns(inspector)
  end

  after(:each) do
    Guard::Minitest::Runner.unstub(:new)
    Guard::Minitest::Inspector.unstub(:new)
  end

  describe 'initialization' do

    it 'should initialize runner with options' do
      Guard::Minitest::Runner.expects(:new).with({}).returns(runner)
      subject.new
    end

    it 'should initialize inspector with options' do
      Guard::Minitest::Inspector.expects(:new).with(runner.test_folders, runner.test_file_patterns).returns(inspector)
      subject.new
    end

  end

  describe 'start' do

    it 'should return true' do
      guard.start.must_equal true
    end

  end

  describe 'stop' do

    it 'should return true' do
      guard.stop.must_equal true
    end

  end

  describe 'reload' do

    it 'should return true' do
      guard.reload.must_equal true
    end

  end

  describe 'run_all' do

    it 'should run all tests' do
      inspector.stubs(:clean_all).returns(['test/guard/minitest/test_inspector.rb', 'test/guard/test_minitest.rb'])
      runner.expects(:run).with(['test/guard/minitest/test_inspector.rb', 'test/guard/test_minitest.rb'], {:message => 'Running all tests'}).returns(true)
      guard.run_all.must_equal true
    end

  end

  describe 'run_on_changes' do

    it 'should run minitest in paths' do
      inspector.stubs(:clean).with(['test/guard/minitest/test_inspector.rb']).returns(['test/guard/minitest/test_inspector.rb'])
      runner.expects(:run).with(['test/guard/minitest/test_inspector.rb']).returns(true)
      guard.run_on_changes(['test/guard/minitest/test_inspector.rb']).must_equal true
    end

  end
end
