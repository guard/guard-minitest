# encoding: utf-8
module Guard
  class Minitest
    module Inspector
      class << self

        def clean(paths)
          paths.uniq!
          paths.compact!
          paths = paths.select { |p| test_file?(p) || test_folder?(p) }

          paths.dup.each do |path|
            if File.directory?(path)
              paths.delete(path)
              %w{test_*.rb *_test.rb *_spec.rb}.each do |file_pattern|
                paths += Dir.glob(File.join(path,'**', file_pattern))
              end
            end
          end

          paths.uniq!
          paths.compact!
          clear_test_files_list
          paths
        end

      private

        def test_folder?(path)
          path.match(/^\/?(test|spec)/) && !path.match(/\..+$/) && File.directory?(path)
        end

        def test_file?(path)
          test_files.include?(path)
        end

        def test_files
          @test_files ||= Dir.glob('test/**/test_*.rb') + Dir.glob('test/**/*_test.rb') + Dir.glob('{test,spec}/**/*_spec.rb')
        end

        def clear_test_files_list
          @test_files = nil
        end

      end
    end
  end
end
