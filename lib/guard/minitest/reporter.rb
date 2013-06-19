# encoding: utf-8
require 'minitest'
require 'guard/minitest/notifier'

module Guard
  class Minitest
    # NB: Minitest 5.0.4 uses ::Minitest:;StatisticsReporter; older minitest uses ::Minitest::Reporter
    parent_class = defined?(::Minitest::StatisticsReporter) ? ::Minitest::StatisticsReporter : ::Minitest::Reporter
    class Reporter < parent_class

      def report
        aggregate = results.group_by { |r| r.failure.class }
        aggregate.default = [] # dumb. group_by should provide this

        f = aggregate[::Minitest::Assertion].size
        e = aggregate[::Minitest::UnexpectedError].size
        s = aggregate[::Minitest::Skip].size
        t = Time.now - start_time

        ::Guard::Minitest::Notifier.notify(count, self.assertions, f, e, s, t)
      end

    end
  end
end
