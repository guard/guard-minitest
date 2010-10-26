# encoding: utf-8
require 'guard'
require 'guard/guard'

module Guard
  class Minitest < Guard

    autoload :Runner,    'guard/minitest/runner'
    autoload :Inspector, 'guard/minitest/inspector'
    autoload :Notifier,  'guard/minitest/notifier'

    def start
      Runner.set_seed(options)
      Runner.set_verbose(options)
      true
    end

    def run_all
      paths = Inspector.clean(['test', 'spec'])
      return Runner.run(paths, :message => 'Running all tests') unless paths.empty?
      true
    end

    def run_on_change(paths = [])
      paths = Inspector.clean(paths)
      return Runner.run(paths) unless paths.empty?
      true
    end
  end
end
