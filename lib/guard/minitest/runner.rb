# encoding: utf-8
module Guard
  class Minitest
    class Runner
      class << self
        attr_reader :seed

        def set_seed(options = {})
          @seed = options[:seed]
        end

        def set_verbose(options = {})
          @verbose = options[:verbose].nil? ? false : !!options[:verbose]
        end

        def verbose?
          @verbose = set_verbose if @verbose.nil?
          @verbose
        end

        def set_notify(options = {})
          @notify = options[:notify].nil? ? true : !!options[:notify]
        end

        def notify?
          @notify = set_notify if @notify.nil?
          @notify
        end

        def set_bundler(options = {})
          @bundler = options[:bundler].nil? ? File.exist?("#{Dir.pwd}/Gemfile") : !!options[:bundler]
        end

        def bundler?
          @bundler = set_bundler if @bundler.nil?
          @bundler
        end

        def set_rubygems(options = {})
          @rubygems = !!options[:rubygems]
        end

        def rubygems?
          @rubygems = set_rubygems if @rubygems.nil?
          bundler? ? false : @rubygems
        end

        def run(paths, options = {})
          message = options[:message] || "Running: #{paths.join(' ')}"
          UI.info message, :reset => true
          system(minitest_command(paths))
        end

        private

        def minitest_command(paths)
          cmd_parts = []
          cmd_parts << "bundle exec" if bundler?
          cmd_parts << 'ruby -Itest -Ispec'
          cmd_parts << '-r rubygems' if rubygems?
          cmd_parts << '-r bundler/setup' if bundler?
          paths.each do |path|
            cmd_parts << "-r #{path}"
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
          cmd_parts.join(' ')
        end

      end
    end
  end
end

