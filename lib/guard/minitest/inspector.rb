# encoding: utf-8
module Guard
  class Minitest
    class Inspector

      attr_reader :test_folders, :test_file_patterns

      def initialize(test_folders, test_file_patterns)
        @test_folders = test_folders.uniq.compact
        @test_file_patterns = test_file_patterns.uniq.compact
      end

      def clean_all
        clean(test_folders)
      end

      def clean(paths)
        paths.reduce([]) do |memo, path|
          if File.directory?(path)
            memo += _test_files_for_paths(path)
          else
            memo << path if _test_file?(path)
          end
          memo
        end.uniq
      end

      def clear_memoized_test_files
        @_all_test_files = nil
      end

      private

      def _test_files_for_paths(paths = test_folders)
        paths = _join_for_glob(Array(paths))
        files = _join_for_glob(test_file_patterns)

        Dir["#{paths}/**/#{files}"]
      end

      def _all_test_files
        @_all_test_files ||= _test_files_for_paths
      end

      def _test_file?(path)
        _all_test_files.include?(path)
      end

      def _join_for_glob(fragments)
        "{#{fragments.join(',')}}"
      end

    end
  end
end
