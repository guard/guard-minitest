# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest::Inspector do
  subject { Guard::Minitest::Inspector }

  describe 'clean' do

    it "should add all test files under the given dir" do
      subject.clean(['test']).must_equal ['test/guard/minitest/test_inspector.rb', 'test/guard/test_minitest.rb']
    end

    it 'should remove non-test files' do
      subject.clean(['test/guard/test_minitest.rb', 'bob.rb']).must_equal ['test/guard/test_minitest.rb']
    end

    it 'should remove non-test existing files' do
      subject.clean(['test/guard/test_minitest.rb', 'test_bob.rb']).must_equal ['test/guard/test_minitest.rb']
    end

    it 'should remove non-test existing files (2)' do
      subject.clean(['test/guard/minitest/test_formatter.rb']).must_equal []
    end

    it 'should keep test folder path' do
      subject.clean(['test/guard/test_minitest.rb', 'test']).must_equal ['test/guard/test_minitest.rb', 'test/guard/minitest/test_inspector.rb']
    end

    it 'should remove duplication' do
      subject.clean(['test/guard/test_minitest.rb', 'test/guard/test_minitest.rb']).must_equal ['test/guard/test_minitest.rb']
    end

    it 'should remove duplication (2)' do
      subject.clean(['test', 'test']).must_equal ['test/guard/minitest/test_inspector.rb', 'test/guard/test_minitest.rb']
    end

    it 'should remove test folder includes in other test folder' do
      subject.clean(['test/minitest', 'test']).must_equal ['test/guard/minitest/test_inspector.rb', 'test/guard/test_minitest.rb']
    end

  end
end
