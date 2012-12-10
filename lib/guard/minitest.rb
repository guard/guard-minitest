# encoding: utf-8
require 'guard'
require 'guard/guard'

module Guard
  class Minitest < Guard

    autoload :Runner,    'guard/minitest/runner'
    autoload :Inspector, 'guard/minitest/inspector'

    def initialize(watchers = [], options = {})
      super

      @runner = Runner.new(options)
      @inspector = Inspector.new(@runner.test_folders, @runner.test_file_patterns)
    end

    def start
      true
    end

    def stop
      true
    end

    def reload
      true
    end

    def run_all
      paths = @inspector.clean_all
      return @runner.run(paths, :message => 'Running all tests') unless paths.empty?
      true
    end

    def run_on_changes(paths = [])
      paths = @inspector.clean(paths)
      return @runner.run(paths) unless paths.empty?
      true
    end
  end
end
