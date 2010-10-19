# encoding: utf-8
module Guard
  class Minitest
    class Runner
      class << self
        attr_reader :seed

        def set_seed(options = {})
          @seed = options[:seed] ||= default_seed
        end

        private

        def default_seed
          srand
          srand % 0xFFFF
        end
      end
    end
  end
end

