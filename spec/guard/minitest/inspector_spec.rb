# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest::Inspector do
  subject { Guard::Minitest::Inspector.new(%w[test spec], %w[*_test.rb test_*.rb *_spec.rb]) }

  describe 'clean' do

    before(:each) do
      @files_on_disk = ['test/guard/minitest/test_inspector.rb', 'test/guard/test_minitest.rb', 'test/guard/minitest_test.rb'].sort
    end

    it "should add all test files under the given dir" do
      subject.clean(['test']).sort.must_equal @files_on_disk
    end

    it 'should remove non-test files' do
      subject.clean(['test/guard/test_minitest.rb', 'bob.rb']).wont_include 'bob.rb'
    end

    it 'should remove non-existing test files' do
      subject.clean(['test/guard/test_minitest.rb', 'test_bob.rb']).wont_include 'test_bob.rb'
    end

    it 'should remove non-test existing files (2)' do
      subject.clean(['test/guard/minitest/test_formatter.rb']).must_equal []
    end

    it 'should keep test folder path' do
      subject.clean(['test/guard/test_minitest.rb', 'test']).sort.must_equal @files_on_disk
    end

    it 'should remove duplication' do
      subject.clean(['test/guard/test_minitest.rb', 'test/guard/test_minitest.rb']).must_equal ['test/guard/test_minitest.rb']
    end

    it 'should remove duplication (2)' do
      subject.clean(['test', 'test']).sort.must_equal @files_on_disk
    end

    it 'should remove test folder includes in other test folder' do
      subject.clean(['test/minitest', 'test']).sort.must_equal @files_on_disk
    end

    it 'should not include test files not in the given dir' do
      subject.clean(['test/guard/minitest']).wont_include 'test/guard/minitest_test.rb'
    end

  end
end
