# encoding: utf-8
module Guard
  class SporkMinitest
    class Runner

      class << self

        def run(paths = [], options = {})
          Runner.new(options).run(paths, options)
        end

      end

      def initialize(options = {})
        @options = {
          :test_folders       => %w[test spec],
          :test_file_patterns => %w[*_test.rb test_*.rb *_spec.rb],
          :cli                => ''
        }.merge(options)

        [:test_folders, :test_file_patterns].each do |k|
          @options[k] = Array(@options[k]).uniq.compact
        end
      end

      def run(paths, options = {})
        message = options[:message] || "Running: #{paths.join(' ')}"
        UI.info message, :reset => true
        system 'testdrb', *paths
      end

      def cli_options
        @options[:cli] ||= ''
      end

      def test_folders
        @options[:test_folders]
      end

      def test_file_patterns
        @options[:test_file_patterns]
      end

    end
  end
end

