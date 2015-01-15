require 'minitest/unit'
require 'guard/minitest/notifier'

module MiniTest
  class MiniTest::Unit
    begin
      alias_method :_run_anything_without_guard, :_run_anything
      def _run_anything(type)
        start = Time.now
        _run_anything_without_guard(type)
        duration = Time.now - start
        ::Guard::Minitest::Notifier.notify(test_count, assertion_count, failures, errors, skips, duration)
      end
    end
  end
end
