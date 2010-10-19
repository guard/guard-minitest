# encoding: utf-8
require 'guard'
require 'guard/guard'

module Guard
  class Minitest < Guard

    autoload :Runner, 'guard/minitest/runner'

    def start
      Runner.set_seed(options)
    end
  end
end
