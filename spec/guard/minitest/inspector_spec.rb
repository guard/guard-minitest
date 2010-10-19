# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest::Inspector do
  subject { Guard::Minitest::Inspector }

  describe 'clean' do

    it 'must_equal remove non-test files' do
      subject.clean(['test/guard/test_minitest.rb', 'bob.rb']).must_equal ['test/guard/test_minitest.rb']
    end

    it 'must_equal remove non-test existing files' do
      subject.clean(['test/guard/test_minitest.rb', 'test_bob.rb']).must_equal ['test/guard/test_minitest.rb']
    end

    it 'must_equal remove non-test existing files (2)' do
      subject.clean(['test/guard/minitest/test_formatter.rb']).must_equal []
    end

    it 'must_equal keep test folder path' do
      subject.clean(['test/guard/test_minitest.rb', 'test/models']).must_equal ['test/guard/test_minitest.rb', 'test/models']
    end

    it 'must_equal remove test folder includes in other test folder' do
      subject.clean(['test/models', 'test']).must_equal ['test']
    end

    it 'must_equal remove test files includes in test folder' do
      subject.clean(['test/guard/test_minitest.rb', 'test']).must_equal ['test']
    end

    it 'must_equal remove test files includes in test folder (2)' do
      subject.clean(['test/guard/test_minitest.rb', 'test/guard/minitest/test_runner.rb', 'test/guard/minitest']).must_equal ['test/guard/test_minitest.rb', 'test/guard/minitest']
    end

    it 'must_equal remove non-spec files' do
      subject.clean(['test/guard/test_minitest.rb', 'bob.rb']).must_equal ['test/guard/test_minitest.rb']
    end

    it 'must_equal remove non-spec existing files' do
      subject.clean(['spec/guard/minitest_spec.rb', 'bob_spec.rb']).must_equal ['spec/guard/minitest_spec.rb']
    end

    it 'must_equal remove non-spec existing files (2)' do
      subject.clean(['spec/guard/minitest/formatter_spec.rb']).must_equal []
    end

    it 'must_equal keep spec folder path' do
      subject.clean(['spec/guard/minitest_spec.rb', 'spec/models']).must_equal ['spec/guard/minitest_spec.rb', 'spec/models']
    end

    it 'must_equal remove spec folder includes in other spec folder' do
      subject.clean(['spec/models', 'spec']).must_equal ['spec']
    end

    it 'must_equal remove spec files includes in spec folder' do
      subject.clean(['spec/guard/minitest_spec.rb', 'spec']).must_equal ['spec']
    end

    it 'must_equal remove spec files includes in spec folder (2)' do
      subject.clean(['spec/guard/minitest_spec.rb', 'spec/guard/minitest/runner_spec.rb', 'spec/guard/minitest']).must_equal ['spec/guard/minitest_spec.rb', 'spec/guard/minitest']
    end

    it 'must_equal remove duplication' do
      subject.clean(['spec', 'spec']).must_equal ['spec']
    end

    it 'must_equal remove duplication (2)' do
      subject.clean(['test', 'test']).must_equal ['test']
    end

    it 'must_equal remove duplication (3)' do
      subject.clean(['test', 'test', 'spec', 'spec']).must_equal ['test', 'spec']
    end

  end

end
