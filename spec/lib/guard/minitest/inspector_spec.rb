require 'guard/minitest/inspector'

RSpec.describe Guard::Minitest::Inspector do
  let(:inspector) { Guard::Minitest::Inspector.new(%w[test spec], %w[*_test.rb test_*.rb *_spec.rb]) }

  describe 'clean' do

    before do
      @files_on_disk = Dir['spec/**/*_spec.rb'].sort
    end

    it "should add all test files under the given dir" do
      expect(inspector.clean(['spec']).sort).to eq @files_on_disk
    end

    it 'should remove non-test files' do
      expect(inspector.clean(['spec/guard/minitest_spec.rb', 'bob.rb'])).to_not include 'bob.rb'
    end

    it 'should remove non-existing test files' do
      expect(inspector.clean(['spec/guard/minitest_spec.rb', 'bob_spec.rb'])).to_not include 'test_bob.rb'
    end

    it 'should remove non-test existing files (2)' do
      expect(inspector.clean(['spec/guard/minitest/formatter_spec.rb'])).to eq []
    end

    it 'should keep test folder path' do
      expect(inspector.clean(['spec/guard/minitest_spec.rb', 'spec']).sort).to eq @files_on_disk
    end

    it 'should remove duplication' do
      expect(inspector.clean(['spec/lib/guard/minitest_spec.rb', 'spec/lib/guard/minitest_spec.rb'])).to eq ['spec/lib/guard/minitest_spec.rb']
    end

    it 'should remove duplication (2)' do
      expect(inspector.clean(['spec', 'spec']).sort).to eq @files_on_disk
    end

    it 'should remove test folder includes in other test folder' do
      expect(inspector.clean(['spec/minitest', 'spec']).sort).to eq @files_on_disk
    end

    it 'should not include test files not in the given dir' do
      expect(inspector.clean(['spec/guard/minitest'])).to_not include 'spec/guard/minitest_spec.rb'
    end

  end
end
