# encoding: utf-8
module Guard
  class Minitest
    class Runner

      class << self

        def run(paths = [], options = {})
          Runner.new(options).run(paths, options)
        end

      end

      def initialize(options = {})
        @options = {
          :verbose  => false,
          :notify   => true,
          :bundler  => File.exist?("#{Dir.pwd}/Gemfile"),
          :rubygems => false,
          :drb      => false,
          :test_folders       => %w[test spec],
          :test_file_patterns => %w[*_test.rb test_*.rb *_spec.rb],
        }.merge(options)
        [:test_folders,:test_file_patterns].each {|k| (@options[k]= [@options[k]].flatten.uniq.compact).freeze}
        options= options.freeze
      end

      def run(paths, options = {})
        message = options[:message] || "Running: #{paths.join(' ')}"
        UI.info message, :reset => true
        system(minitest_command(paths))
      end

      def seed
        @options[:seed]
      end

      def verbose?
        @options[:verbose]
      end

      def notify?
        @options[:notify]
      end

      def bundler?
        @options[:bundler]
      end

      def rubygems?
        !bundler? && @options[:rubygems]
      end

      def drb?
        @options[:drb]
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
        cmd_parts << "bundle exec" if bundler?
        if drb?
          cmd_parts << 'testdrb'
          cmd_parts << "-r #{File.expand_path('../runners/default_runner.rb', __FILE__)}"
          if notify?
            cmd_parts << '-e \'::GUARD_NOTIFY=true\''
          else
            cmd_parts << '-e \'::GUARD_NOTIFY=false\''
          end
          test_folders.each do |f|
            cmd_parts << "#{f}/test_helper.rb" if File.exist?("#{f}/test_helper.rb")
            cmd_parts << "#{f}/spec_helper.rb" if File.exist?("#{f}/spec_helper.rb")
          end
          paths.each do |path|
            cmd_parts << "./#{path}"
          end
        else
          cmd_parts << 'ruby'
          cmd_parts.concat test_folders.map{|f| %[-I"#{f}"]}
          cmd_parts << '-r rubygems' if rubygems?
          cmd_parts << '-r bundler/setup' if bundler?
          paths.each do |path|
            cmd_parts << "-r ./#{path}"
          end
          cmd_parts << "-r #{File.expand_path('../runners/default_runner.rb', __FILE__)}"
          if notify?
            cmd_parts << '-e \'GUARD_NOTIFY=true; MiniTest::Unit.autorun\''
          else
            cmd_parts << '-e \'GUARD_NOTIFY=false; MiniTest::Unit.autorun\''
          end
          cmd_parts << '--'
          cmd_parts << "--seed #{seed}" unless seed.nil?
          cmd_parts << '--verbose' if verbose?
        end
        cmd= cmd_parts.join(' ')
        puts "Running: #{cmd}\n\n" if verbose?
        cmd
      end

    end
  end
end

