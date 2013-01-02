# encoding: utf-8
require 'spec_helper'
require 'guard/sporkminitest/notifier'

describe 'Guard::SporkMinitestNotifier' do
  subject { Guard::SporkMinitestNotifier }

  it 'should format message without skipped test' do
    message = subject.guard_message(1, 2, 3, 4, 0, 10.0)
    message.must_equal "1 examples, 2 assertions, 3 failures, 4 errors\nin 10.000000 seconds, 0.1000 tests/s, 0.2000 assertions/s."
  end

  it 'should format message with skipped test' do
    message = subject.guard_message(1, 2, 3, 4, 5, 10.0)
    message.must_equal "1 examples, 2 assertions, 3 failures, 4 errors (5 skips)\nin 10.000000 seconds, 0.1000 tests/s, 0.2000 assertions/s."
  end

  it 'should select failed image' do
    subject.guard_image(1, 2).must_equal :failed
    subject.guard_image(1, 0).must_equal :failed
  end

  it 'should select pending image' do
    subject.guard_image(0, 2).must_equal :pending
  end

  it 'should select success image' do
    subject.guard_image(0, 0).must_equal :success
  end

  it 'should call Guard::Notifier' do
    ::Guard::Notifier.expects(:notify).with(
      "1 examples, 2 assertions, 0 failures, 0 errors\nin 10.000000 seconds, 0.1000 tests/s, 0.2000 assertions/s.",
      :title => 'MiniTest results',
      :image => :success
    )
    subject.notify(1, 2, 0, 0, 0, 10.0)
  end

end
