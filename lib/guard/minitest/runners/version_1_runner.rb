# encoding: utf-8
require 'minitest/unit'
require 'guard/minitest/notifier'

module MiniTest
  class MiniTest::Unit

    alias_method :run_without_guard, :run
    def run(args = [])
      start = Time.now
      run_without_guard(args)
      duration = Time.now - start
      ::Guard::MinitestNotifier.notify(test_count, assertion_count, failures, errors, skips, duration)
    end

  end
end
