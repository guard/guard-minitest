require 'spec_helper'

describe Guard::Minitest do
  subject { Guard::Minitest }

  let(:runner) { Guard::Minitest::Runner }
  let(:guard) { subject.new }

  describe 'initialization' do
    it 'initializes runner with default options' do
      runner.expects(:new).with({ all_on_start: true })

      subject.new
    end
  end

  describe 'start' do
    it 'runs all tests at start via runner' do
      subject.any_instance.expects(:run_all)

      subject.new.start
    end

    it 'do not run all tests if you pass run_all_on_start: false' do
      subject.any_instance.expects(:run_all).never

      subject.new(all_on_start: false).start
    end
  end

  describe 'stop' do
    it 'returns true' do
      guard.stop.must_equal true
    end
  end

  describe 'reload' do
    it 'returns true' do
      guard.reload.must_equal true
    end
  end

  describe 'run_on_modifications' do
    it 'is run through runner' do
      runner.any_instance.expects(:run_on_modifications => true)
      guard.run_on_modifications
    end
  end

  describe 'run_on_additions' do
    let(:paths) { %w[path1 path2] }

    it 'is run through runner' do
      runner.any_instance.expects(:run_on_additions).with(paths)

      guard.run_on_additions(paths)
    end
  end

  describe 'run_on_removals' do
    let(:paths) { %w[path1 path2] }

    it 'runs run_on_removals via runner' do
      runner.any_instance.expects(:run_on_removals).with(paths)

      guard.run_on_removals(paths)
    end
  end

  describe 'halting and throwing on test failure' do
    it 'throws on failed test run' do
      stubbed_runner = double
      stubbed_runner.stubs(:run).returns(false)
      stubbed_runner.expects(:run_all)
      stubbed_runner.expects(:run_on_modifications)

      guard.runner = stubbed_runner

      proc { guard.run_all }.must_throw :task_has_failed
      proc { guard.run_on_modifications }.must_throw :task_has_failed
    end
  end
end
