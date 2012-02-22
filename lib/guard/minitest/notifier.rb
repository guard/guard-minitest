# encoding: utf-8
require 'guard/notifier'

module Guard
  class MinitestNotifier

    def self.guard_message(test_count, assertion_count, failure_count, error_count, skip_count, duration)
      message = "#{test_count} examples, #{assertion_count} assertions, #{failure_count} failures, #{error_count} errors"
      if skip_count > 0
        message << " (#{skip_count} skips)"
      end
      if test_count && assertion_count
        message << "\nin %.6f seconds, %.4f tests/s, %.4f assertions/s." % [duration, test_count / duration, assertion_count / duration]
      end
      message
    end

    # failed | pending (skip) | success
    def self.guard_image(failure_count, skip_count)
      icon = if failure_count > 0
        :failed
      elsif skip_count > 0
        :pending
      else
        :success
      end
    end

    def self.notify(test_count, assertion_count, failure_count, error_count, skip_count, duration)
      message = guard_message(test_count, assertion_count, failure_count, error_count, skip_count, duration)
      image   = guard_image(failure_count + error_count, skip_count)

      ::Guard::Notifier.notify(message, :title => 'MiniTest results', :image => image)
    end

  end
end
