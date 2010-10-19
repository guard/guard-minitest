# encoding: utf-8
module Guard
  class Minitest
    module Inspector
      class << self

        def clean(paths)
          paths.uniq!
          paths.compact!
          paths = paths.select { |p| test_file?(p) || test_folder?(p) }
          paths = paths.delete_if { |p| included_in_other_path?(p, paths) }
          clear_test_files_list
          paths
        end

      private

        def test_folder?(path)
          path.match(/^\/?(test|spec)/) && !path.match(/\..+$/)
        end

        def test_file?(path)
          test_files.include?(path)
        end

        def test_files
          @test_files ||= Dir.glob('test/**/test_*.rb') + Dir.glob('spec/**/*_spec.rb')
        end

        def clear_test_files_list
          @test_files = nil
        end

        def included_in_other_path?(path, paths)
          paths = paths.select { |p| p != path }
          paths.any? { |p| path.include?(p) && (path.gsub(p, '')).include?('/') }
        end

      end
    end
  end
end