# encoding: utf-8
module Guard
  class Minitest
    class Runner

      def self.run(paths = [], options = {})
        Runner.new(options).run(paths, options)
      end

      def initialize(options = {})
        @options = {
          :bundler            => File.exist?("#{Dir.pwd}/Gemfile"),
          :rubygems           => false,
          :drb                => false,
          :zeus               => false,
          :spring             => false,
          :test_folders       => %w[test spec],
          :test_file_patterns => %w[*_test.rb test_*.rb *_spec.rb],
          :cli                => nil
        }.merge(options)

        parse_deprecated_options

        [:test_folders, :test_file_patterns].each do |k|
          @options[k] = Array(@options[k]).uniq.compact
        end
      end

      def run(paths, options = {})
        message = options[:message] || "Running: #{paths.join(' ')}"
        UI.info message, :reset => true
        system(minitest_command(paths))
      end

      def cli_options
        @cli_options ||= Array(@options[:cli])
      end

      def bundler?
        @options[:bundler] && ! @options[:spring]
      end

      def rubygems?
        !bundler? && @options[:rubygems]
      end

      def drb?
        @options[:drb]
      end

      def zeus?
        @options[:zeus].is_a?(String) || @options[:zeus]
      end

      def spring?
        @options[:spring]
      end

      def test_folders
        @options[:test_folders]
      end

      def test_file_patterns
        @options[:test_file_patterns]
      end

      private

      def minitest_command(paths)
        cmd_parts = []

        cmd_parts << 'bundle exec' if bundler?
        cmd_parts << if drb?
          drb_command(paths)
        elsif zeus?
          zeus_command(paths)
        elsif spring?
          spring_command(paths)
        else
          ruby_command(paths)
        end

        cmd_parts.compact.join(' ')
      end

      def drb_command(paths)
        %w[testdrb -Itest] + relative_paths(paths)
      end

      def zeus_command(paths)
        command = @options[:zeus].is_a?(String) ? @options[:zeus] : 'test'

        ['zeus', command] + relative_paths(paths)
      end

      def spring_command(paths)
        ['spring testunit', File.expand_path('../runners/default_runner.rb', __FILE__)] + relative_paths(paths)
      end

      def ruby_command(paths)
        cmd_parts  = ['ruby']
        cmd_parts += test_folders.map {|f| %[-I"#{f}"] }
        cmd_parts << '-r rubygems' if rubygems?
        cmd_parts << '-r bundler/setup' if bundler?
        cmd_parts += paths.map { |path| "-r ./#{path}" }
        cmd_parts << "-r #{File.expand_path('../runners/default_runner.rb', __FILE__)}"
        if ::MiniTest::Unit::VERSION =~ /^5/
          cmd_parts << '-e \'Minitest.autorun\''
        else
          cmd_parts << '-e \'MiniTest::Unit.autorun\''
        end
        cmd_parts << '--'
        cmd_parts += cli_options
        cmd_parts << '-p' # uses pride for output colorization
      end

      def relative_paths(paths)
        paths.map { |p| "./#{p}" }
      end

      def parse_deprecated_options
        if @options.key?(:notify)
          UI.info %{DEPRECATION WARNING: The :notify option is deprecated. Guard notification configuration is used.}
        end

        [:seed, :verbose].each do |key|
          if value = @options.delete(key)
            final_value = "--#{key}"
            final_value << " #{value}" unless [TrueClass, FalseClass].include?(value.class)
            cli_options << final_value

            UI.info %{DEPRECATION WARNING: The :#{key} option is deprecated. Pass standard command line argument "--#{key}" to Minitest with the :cli option.}
          end
        end
      end

    end
  end
end
