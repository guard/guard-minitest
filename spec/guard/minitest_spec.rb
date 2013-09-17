# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest do
  subject { Guard::Minitest }

  let(:runner) { stub('runner', test_folders: [], test_file_patterns: []) }
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

    it 'initializes runner with options' do
      Guard::Minitest::Runner.expects(:new).with({ all_on_start: true }).returns(runner)
      subject.new
    end

    it 'initializes inspector with options' do
      Guard::Minitest::Inspector.expects(:new).with(runner.test_folders, runner.test_file_patterns).returns(inspector)
      subject.new
    end

  end

  describe 'start' do

    it 'runs all tests at start' do
      subject.any_instance.expects(:run_all)

      subject.new.start
    end

    it 'do not run all tests if you pass run_all_on_start: false' do
      subject.any_instance.expects(:run_all).never

      subject.new(all_on_start: false)
    end

  end

  describe 'stop' do
    it 'returns true' do
      subject.new.stop.must_equal true
    end
  end

  describe 'reload' do
    it 'returns true' do
      subject.new.reload.must_equal true
    end
  end

  describe 'run_all' do
    it 'runs all tests' do
      inspector.stubs(:clean_all).returns(['test/guard/minitest/test_inspector.rb', 'test/guard/test_minitest.rb'])
      runner.expects(:run).with(['test/guard/minitest/test_inspector.rb', 'test/guard/test_minitest.rb'], {message: 'Running all tests'}).returns(true)

      subject.new.run_all.must_equal true
    end
  end

  describe 'run_on_changes' do
    it 'runs minitest in paths' do
      inspector.stubs(:clean).with(['test/guard/minitest/test_inspector.rb']).returns(['test/guard/minitest/test_inspector.rb'])
      runner.expects(:run).with(['test/guard/minitest/test_inspector.rb']).returns(true)

      subject.new.run_on_changes(['test/guard/minitest/test_inspector.rb']).must_equal true
    end
  end

  describe 'run_on_additions' do
    it 'clears the test file cache and runs minitest for the new path' do
      inspector.stubs(:clean).with(['test/guard/minitest/test_new.rb']).returns(['test/guard/minitest/test_new.rb'])

      inspector.expects(:clear_memoized_test_files)
      runner.expects(:run).with(['test/guard/minitest/test_new.rb']).returns(true)

      subject.new.run_on_additions(['test/guard/minitest/test_new.rb']).must_equal true
    end
  end

  describe 'run_on_removals' do
    it 'clears the test file cache and does not run minitest' do
      inspector.stubs(:clean).with(['test/guard/minitest/test_deleted.rb']).returns(['test/guard/minitest/test_deleted.rb'])

      inspector.expects(:clear_memoized_test_files)
      runner.expects(:run).never

      subject.new.run_on_removals(['test/guard/minitest/test_deleted.rb'])
    end

  end
end
