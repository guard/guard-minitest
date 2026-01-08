require 'guard/minitest'

RSpec.describe Guard::Minitest do
  subject { Guard::Minitest }

  let(:runner) { Guard::Minitest::Runner }
  let(:guard) { subject.new }

  describe 'initialization' do
    it 'initializes runner with default options' do
      expect(runner).to receive(:new).with({ all_on_start: true })

      subject.new
    end
  end

  describe 'start' do
    it 'runs all tests at start via runner' do
      expect_any_instance_of(subject).to receive(:run_all)

      subject.new.start
    end

    it 'do not run all tests if you pass run_all_on_start: false' do
      expect_any_instance_of(subject).to receive(:run_all).never

      subject.new(all_on_start: false).start
    end
  end

  describe 'stop' do
    it 'returns true' do
      expect(guard.stop).to eq true
    end
  end

  describe 'reload' do
    it 'returns true' do
      expect(guard.reload).to eq true
    end
  end

  describe 'run_on_modifications' do
    it 'is run through runner' do
      expect_any_instance_of(runner).to receive(:run_on_modifications)
        .and_return(true)

      guard.run_on_modifications
    end
  end

  describe 'run_on_additions' do
    let(:paths) { %w(path1 path2) }

    it 'is run through runner' do
      expect_any_instance_of(runner).to receive(:run_on_additions).with(paths)

      guard.run_on_additions(paths)
    end
  end

  describe 'run_on_removals' do
    let(:paths) { %w(path1 path2) }

    it 'runs run_on_removals via runner' do
      expect_any_instance_of(runner).to receive(:run_on_removals).with(paths)

      guard.run_on_removals(paths)
    end
  end

  describe 'halting and throwing on test failure' do
    it 'throws on failed test run' do
      stubbed_runner = double
      allow(stubbed_runner).to receive(:run).and_return(false)
      expect(stubbed_runner).to receive(:run_all)
      expect(stubbed_runner).to receive(:run_on_modifications)

      guard.runner = stubbed_runner

      expect { guard.run_all }.to throw_symbol :task_has_failed
      expect { guard.run_on_modifications }.to throw_symbol :task_has_failed
    end
  end
end
