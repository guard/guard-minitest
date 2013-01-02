# encoding: utf-8
require 'spec_helper'
describe Guard::SporkMinitest::Runner do
  subject { Guard::SporkMinitest::Runner }

  describe 'options' do
    describe 'cli_options' do
      it 'default should be empty string' do
        subject.new.cli_options.must_equal ''
      end
      it 'should be set with \'cli\'' do
        subject.new(:cli => '--test').cli_options.must_equal '--test'
      end
    end
  end

  describe 'run' do
    before(:each) do
      Dir.stubs(:pwd).returns(fixtures_path.join('empty'))
    end
    describe 'drb' do
      it 'should run with drb' do
        runner = subject.new(:test_folders => %w[test], :drb => true)
        Guard::UI.expects(:info)
        runner.expects(:system).with *%w(testdrb test/test_minitest.rb)
        runner.run(['test/test_minitest.rb'], :drb => true)
      end
    end
  end
end
