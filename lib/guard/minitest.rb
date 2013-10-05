# encoding: utf-8
require 'guard'
require 'guard/plugin'

module Guard
  class Minitest < Plugin

    require 'guard/minitest/inspector'
    require 'guard/minitest/runner'
    require 'guard/minitest/version'

    def initialize(options = {})
      super
      @options = {
        all_on_start: true
      }.merge(options)

      @runner    = Runner.new(@options)
      @inspector = Inspector.new(@runner.test_folders, @runner.test_file_patterns)
    end

    def start
      UI.info "Guard::Minitest #{MinitestVersion::VERSION} is running, with Minitest::Unit #{_minitest_version}!"
      run_all if @options[:all_on_start]
    end

    def stop
      true
    end

    def reload
      true
    end

    def run_all
      paths = @inspector.clean_all
      @runner.run(paths, message: 'Running all tests')
    end

    def run_on_changes(paths = [])
      paths = @inspector.clean(paths)
      @runner.run(paths)
    end

    def run_on_additions(paths)
      @inspector.clear_memoized_test_files
      @runner.run(paths)
    end

    def run_on_removals(paths)
      @inspector.clear_memoized_test_files
    end

    private

    def _minitest_version
      @_minitest_version ||= begin
        require 'minitest'
        ::Minitest::VERSION

      rescue LoadError, NameError
        require 'minitest/unit'
        ::MiniTest::Unit::VERSION
      end
    end

  end
end
