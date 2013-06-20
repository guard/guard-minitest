# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest::Inspector do
  let(:inspector) { Guard::Minitest::Inspector.new(%w[test spec], %w[*_test.rb test_*.rb *_spec.rb]) }

  describe 'clean' do

    before do
      @files_on_disk = Dir['spec/**/*_spec.rb'].sort#'spec/guard/minitest/inspector_spec.rb', 'spec/guard/minitest_spec.rb', 'spec/guard/minitest_spec.rb'].sort
    end

    it "should add all test files under the given dir" do
      inspector.clean(['spec']).sort.must_equal @files_on_disk
    end

    it 'should remove non-test files' do
      inspector.clean(['spec/guard/minitest_spec.rb', 'bob.rb']).wont_include 'bob.rb'
    end

    it 'should remove non-existing test files' do
      inspector.clean(['spec/guard/minitest_spec.rb', 'bob_spec.rb']).wont_include 'test_bob.rb'
    end

    it 'should remove non-test existing files (2)' do
      inspector.clean(['spec/guard/minitest/formatter_spec.rb']).must_equal []
    end

    it 'should keep test folder path' do
      inspector.clean(['spec/guard/minitest_spec.rb', 'spec']).sort.must_equal @files_on_disk
    end

    it 'should remove duplication' do
      inspector.clean(['spec/guard/minitest_spec.rb', 'spec/guard/minitest_spec.rb']).must_equal ['spec/guard/minitest_spec.rb']
    end

    it 'should remove duplication (2)' do
      inspector.clean(['spec', 'spec']).sort.must_equal @files_on_disk
    end

    it 'should remove test folder includes in other test folder' do
      inspector.clean(['spec/minitest', 'spec']).sort.must_equal @files_on_disk
    end

    it 'should not include test files not in the given dir' do
      inspector.clean(['spec/guard/minitest']).wont_include 'spec/guard/minitest_spec.rb'
    end

  end
end
