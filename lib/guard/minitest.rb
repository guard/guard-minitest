# encoding: utf-8
require 'guard'
require 'guard/guard'

module Guard
  class Minitest < Guard

    autoload :Runner,    'guard/minitest/runner'
    autoload :Inspector, 'guard/minitest/inspector'

    def start
      @runner ||= Runner.new(options)
      true
    end

    def run_all
      paths = Inspector.clean(['test', 'spec'])
      return @runner.run(paths, :message => 'Running all tests') unless paths.empty?
      true
    end

    def run_on_change(paths = [])
      paths = Inspector.clean(paths)
      return @runner.run(paths) unless paths.empty?
      true
    end
  end
end
