require 'guard/minitest/inspector'

module Guard
  class Minitest
    class Runner
      attr_accessor :inspector

      def initialize(options = {})
        @options = {
          all_after_pass:     false,
          bundler:            File.exist?("#{Dir.pwd}/Gemfile"),
          rubygems:           false,
          drb:                false,
          zeus:               false,
          spring:             false,
          all_env:            {},
          env:                {},
          include:            [],
          test_folders:       %w[test spec],
          test_file_patterns: %w[*_test.rb test_*.rb *_spec.rb],
          cli:                nil,
          autorun:            true
        }.merge(options)

        parse_deprecated_options

        [:test_folders, :test_file_patterns].each do |k|
          @options[k] = Array(@options[k]).uniq.compact
        end

        @inspector = Inspector.new(test_folders, test_file_patterns)
      end

      def run(paths, options = {})
        message = "Running: #{options[:all] ? 'all tests' : paths.join(' ')}"
        UI.info message, reset: true

        status = _run_command(paths, options[:all])

        # When using zeus or spring, the Guard::Minitest::Reporter can't be used because the minitests run in another
        # process, but we can use the exit status of the client process to distinguish between :success and :failed.
        if zeus? || spring?
          ::Guard::Notifier.notify(message, title: 'Minitest results', image: status ? :success : :failed)
        end

        if @options[:all_after_pass] && status && !options[:all]
           run_all
        else
          status
        end
      end

      def run_all
        paths = inspector.clean_all
        run(paths, all: true)
      end

      def run_on_modifications(paths = [])
        paths = inspector.clean(paths)
        run(paths, all: all_paths?(paths))
      end

      def run_on_additions(paths)
        inspector.clear_memoized_test_files
        true
      end

      def run_on_removals(paths)
        inspector.clear_memoized_test_files
      end

      private

      def cli_options
        @cli_options ||= Array(@options[:cli])
      end

      def bundler?
        @options[:bundler] && !@options[:spring]
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
        @options[:spring].is_a?(String) || @options[:spring]
      end

      def all_after_pass?
        @options[:all_after_pass]
      end

      def test_folders
        @options[:test_folders]
      end

      def include_folders
        @options[:include]
      end

      def test_file_patterns
        @options[:test_file_patterns]
      end

      def autorun?
        @options[:autorun]
      end

      def _run_command(paths, all)
        if bundler?
          system(*minitest_command(paths, all))
        else
          if defined?(::Bundler)
            ::Bundler.with_clean_env do
              system(*minitest_command(paths, all))
            end
          else
            system(*minitest_command(paths, all))
          end
        end
      end

      def _commander(paths)
        if drb?
          drb_command(paths)
        elsif zeus?
          zeus_command(paths)
        elsif spring?
          spring_command(paths)
        else
          ruby_command(paths)
        end
      end

      def minitest_command(paths, all)
        cmd_parts = []

        cmd_parts << 'bundle exec' if bundler?
        cmd_parts << _commander(paths)

        [cmd_parts.compact.join(' ')].tap do |args|
          env = generate_env(all)
          args.unshift(env) if env.length > 0
        end
      end

      def drb_command(paths)
        %w[testdrb] + generate_includes(false) + relative_paths(paths)
      end

      def zeus_command(paths)
        command = @options[:zeus].is_a?(String) ? @options[:zeus] : 'test'
        ['zeus', command] + relative_paths(paths)
      end

      def spring_command(paths)
        command = @options[:spring].is_a?(String) ? @options[:spring] : 'bin/rake test'
        cmd_parts = [command]
        cmd_parts << File.expand_path('../runners/old_runner.rb', __FILE__) unless (Utils.minitest_version_gte_5? || command != 'spring testunit')
        if cli_options.length > 0
          cmd_parts + paths + ['--'] + cli_options
        else
          cmd_parts + paths
        end
      end

      def ruby_command(paths)
        cmd_parts  = ['ruby']
        cmd_parts.concat(generate_includes)
        cmd_parts << '-r rubygems' if rubygems?
        cmd_parts << '-r bundler/setup' if bundler?
        cmd_parts << '-r minitest/autorun' if autorun?
        cmd_parts.concat(paths.map { |path| "-r ./#{path}" })

        unless Utils.minitest_version_gte_5?
          cmd_parts << "-r #{File.expand_path('../runners/old_runner.rb', __FILE__)}"
        end

        # All the work is done through minitest/autorun
        # and requiring the test files, so this is just
        # a placeholder so Ruby doesn't try to exceute
        # code from STDIN.
        cmd_parts << '-e ""'

        cmd_parts << '--'
        cmd_parts += cli_options
      end

      def generate_includes(include_test_folders = true)
        if include_test_folders
          folders = test_folders + include_folders
        else
          folders = include_folders
        end
        
        folders.map {|f| %[-I"#{f}"] }
      end

      def generate_env(all=false)
        base_env.merge(all ? all_env : {})
      end

      def base_env
        Hash[(@options[:env] || {}).map{|key, value| [key.to_s, value.to_s]}]
      end

      def all_env
        if @options[:all_env].kind_of? Hash
          Hash[@options[:all_env].map{|key, value| [key.to_s, value.to_s]}]
        else
          {@options[:all_env].to_s => "true"}
        end
      end

      def relative_paths(paths)
        paths.map { |p| "./#{p}" }
      end

      def all_paths?(paths)
        paths == inspector.all_test_files
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
