# encoding: utf-8
require 'minitest/unit'
require 'guard/minitest/notifier'

module MiniTest
  class Unit

    # Compatibility with version 1.7
    if VERSION <= '1.7.2'
      attr_accessor :options, :help

      def run(args = [])
        self.options = process_args(args)

        unless options[:seed] then
          srand
          options[:seed] = srand % 0xFFFF
        end

        self.help =  ['--seed', options[:seed].to_s]
        self.help << ['--verbose'] if options[:verbose]
        self.help =  self.help.join(' ')

        run_all_tests

        return failures + errors if @test_count > 0 # or return nil...
      rescue Interrupt
        abort 'Interrupted'
      end

      def drive_tests(filters = /./)
        run_test_suites(filters)
      end
    end

    # Rewrite default runner to use notification
    def run_all_tests
      @@out.puts "Test run options: #{help}"
      @@out.puts
      @@out.puts 'Started'

      start = Time.now
      drive_tests(/./)
      duration = Time.now - start

      @@out.puts
      @@out.puts "Finished in %.6f seconds, %.4f tests/s, %.4f assertions/s." %
      [duration, test_count / duration, assertion_count / duration]

      report.each_with_index do |msg, i|
        @@out.puts "\n%3d) %s" % [i + 1, msg]
      end

      @@out.puts

      status
      Guard::Minitest::Notifier.notify(test_count, assertion_count, failures, errors, skips, duration)

      @@out.puts
      @@out.puts "Test run options: #{help}"
    end
  end
end
