require 'minitest'
require 'guard/minitest/notifier'

module Guard
  class Minitest
    class Reporter < ::Minitest::StatisticsReporter

      def report
        super

        ::Guard::Minitest::Notifier.notify(self.count, self.assertions,
                                           self.failures, self.errors,
                                           self.skips, self.total_time)
      end

    end
  end
end
