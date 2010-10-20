# encoding: utf-8
require 'guard'
require 'guard/guard'

module Guard
  class Minitest < Guard

    autoload :Runner,    'guard/minitest/runner'
    autoload :Inspector, 'guard/minitest/inspector'

    def start
      Runner.set_seed(options)
    end

    def run_all
      Runner.run(Inspector.clean(['test', 'spec']), :message => 'Running all tests')
    end

    def run_on_change(paths = [])
      paths = Inspector.clean(paths)
      Runner.run(Inspector.clean(paths)) unless paths.empty?
    end
  end
end
