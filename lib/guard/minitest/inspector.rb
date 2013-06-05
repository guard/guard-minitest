# encoding: utf-8
module Guard
  class Minitest
    class Inspector

      attr_reader :test_folders, :test_file_patterns

      def initialize(test_folders, test_file_patterns)
        @test_folders = test_folders.uniq.compact.freeze
        @test_file_patterns = test_file_patterns.uniq.compact.freeze
      end

      def clean_all
        clean(test_folders)
      end

      def clean(paths)
        paths = paths.uniq.compact unless paths == @test_folders
        paths = paths.select { |p| test_file?(p) || test_folder?(p) }

        paths.dup.each do |path|
          if File.directory?(path)
            paths.delete(path)
            paths += test_files_for_paths([path])
          end
        end

        paths.uniq!
        paths.compact!
        clear_test_files_list
        paths
      end

      private

      def test_folder_regex
        @_test_folder_regex ||= begin
          folders = test_folders.map { |f| Regexp.quote(f) }.join('|')
          Regexp.new("^/?(?:#{folders})(?:/|$)")
        end
      end

      def test_folder?(path)
        path.match(test_folder_regex) && !path.match(/\..+$/) && File.directory?(path)
      end

      def test_file?(path)
        test_files.include?(path)
      end

      def test_files
        @_test_files ||= test_files_for_paths(test_folders)
      end

      def join_for_glob(fragments)
        "{#{fragments.join(',')}}"
      end

      def test_files_for_paths(paths)
        paths = join_for_glob(paths)
        files = join_for_glob(test_file_patterns)
        Dir.glob(paths + '/**/' + files)
      end

      def clear_test_files_list
        @_test_files = nil
      end

    end
  end
end
