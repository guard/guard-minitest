# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest do
  subject { Guard::Minitest.new }

  describe 'start' do

    it 'should set seed option' do
      Guard::Minitest::Runner.expects(:set_seed)
      subject.start
    end

    it 'should set verbose option' do
      Guard::Minitest::Runner.expects(:set_verbose)
      subject.start
    end

    it 'should set bundler option' do
      Guard::Minitest::Runner.expects(:set_bundler)
      subject.start
    end

    it 'should set bundler option' do
      Guard::Minitest::Runner.expects(:set_rubygems)
      subject.start
    end

  end

  describe 'run_all' do

    it 'should run all tests' do
      Guard::Minitest::Inspector.stubs(:clean).with(['test', 'spec']).returns(['test/guard/minitest/test_inspector.rb', 'test/guard/test_minitest.rb'])
      Guard::Minitest::Runner.expects(:run).with(['test/guard/minitest/test_inspector.rb', 'test/guard/test_minitest.rb'], {:message => 'Running all tests'})
      subject.run_all
    end

  end

  describe 'runn_on_change' do

    it 'should run minitest in paths' do
      Guard::Minitest::Runner.expects(:run).with(['test/guard/minitest/test_inspector.rb'])
      subject.run_on_change(['test/guard/minitest/test_inspector.rb'])
    end
  end
end

def new_guard_with_options(options = {})
  Guard::Minitest.new([], options)
end
