require 'guard/minitest/notifier'

RSpec.describe Guard::Minitest::Notifier do
  subject { Guard::Minitest::Notifier }

  describe '.guard_message' do
    it 'should format message without skipped test' do
      expect(subject.guard_message(1, 2, 3, 4, 0, 10.0)).to eq "1 tests\n2 assertions, 3 failures, 4 errors\n\n0.10 tests/s, 0.20 assertions/s\n\nFinished in 10.0000 seconds"
    end

    it 'should format message with skipped test' do
      expect(subject.guard_message(1, 2, 3, 4, 5, 10.0)).to eq "1 tests (5 skipped)\n2 assertions, 3 failures, 4 errors\n\n0.10 tests/s, 0.20 assertions/s\n\nFinished in 10.0000 seconds"
    end
  end

  describe '.guard_image' do
    it 'should select failed image' do
      expect(subject.guard_image(1, 2)).to eq :failed
      expect(subject.guard_image(1, 0)).to eq :failed
    end

    it 'should select pending image' do
      expect(subject.guard_image(0, 2)).to eq :pending
    end

    it 'should select success image' do
      expect(subject.guard_image(0, 0)).to eq :success
    end
  end

  describe '.notify' do
    it 'should call Guard::Notifier' do
      allow(::Guard::Notifier).to receive(:notify).with(
        "1 tests\n2 assertions, 0 failures, 0 errors\n\n0.10 tests/s, 0.20 assertions/s\n\nFinished in 10.0000 seconds",
        title: 'Minitest results',
        image: :success
      )

      subject.notify(1, 2, 0, 0, 0, 10.0)
    end
  end

end
