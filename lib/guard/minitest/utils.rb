require 'rubygems/requirement'

module Guard
  class Minitest
    class Utils

      def self.minitest_version
        @@minitest_version ||= begin
          require 'minitest'
          ::Minitest::VERSION

        rescue LoadError, NameError
          require 'minitest/unit'
          ::MiniTest::Unit::VERSION
        end
      end

      def self.minitest_version_gte_5?
        @@minitest_version_gte_5 ||= Gem::Requirement.new('>= 5').satisfied_by?(Gem::Version.new(minitest_version))
      end

      def self.minitest_version_gte_5_0_4?
        @@minitest_version_gte_5_0_4 ||= Gem::Requirement.new('>= 5.0.4').satisfied_by?(Gem::Version.new(minitest_version))
      end

    end
  end
end
