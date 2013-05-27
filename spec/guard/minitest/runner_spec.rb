# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest::Runner do
  subject { Guard::Minitest::Runner }

  before do
    @minitest_autorun = ::MiniTest::Unit::VERSION =~ /^5/ ? 'Minitest.autorun' : 'MiniTest::Unit.autorun'
  end

  describe 'options' do

    describe 'cli_options' do
      it 'default should be empty string' do
        subject.new.cli_options.must_equal []
      end

      it 'should be set with \'cli\'' do
        subject.new(:cli => '--test').cli_options.must_equal ['--test']
      end
    end

    describe 'deprecated options' do
      describe 'seed' do
        it 'should set cli options' do
          Guard::UI.expects(:info).with('DEPRECATION WARNING: The :seed option is deprecated. Pass standard command line argument "--seed" to Minitest with the :cli option.')
          subject.new(:seed => 123456789).cli_options.must_equal ['--seed 123456789']
        end
      end

      describe 'verbose' do
        it 'should set cli options' do
          Guard::UI.expects(:info).with('DEPRECATION WARNING: The :verbose option is deprecated. Pass standard command line argument "--verbose" to Minitest with the :cli option.')
          subject.new(:verbose => true).cli_options.must_equal ['--verbose']
        end
      end
    end

    describe 'bundler' do
      it 'default should be true if Gemfile exist' do
        Dir.stubs(:pwd).returns(fixtures_path.join('bundler'))
        subject.new.bundler?.must_equal true
      end

      it 'default should be false if Gemfile don\'t exist' do
        Dir.stubs(:pwd).returns(fixtures_path.join('empty'))
        subject.new.bundler?.must_equal false
      end

      it 'should be forced to false' do
        Dir.stubs(:pwd).returns(fixtures_path.join('bundler'))
        subject.new(:bundler => false).bundler?.must_equal false
      end

      it 'should be forced to false if spring is enabled' do
        Dir.stubs(:pwd).returns(fixtures_path.join('bundler'))
        subject.new(:spring => true).bundler?.must_equal false
      end
    end

    describe 'rubygems' do
      it 'default should be false if Gemfile exist' do
        Dir.stubs(:pwd).returns(fixtures_path.join('bundler'))
        subject.new.rubygems?.must_equal false
      end

      it 'default should be false if Gemfile don\'t exist' do
        Dir.stubs(:pwd).returns(fixtures_path.join('empty'))
        subject.new.rubygems?.must_equal false
      end

      it 'should be set to true if bundler is disabled' do
        subject.new(:bundler => false, :rubygems => true).rubygems?.must_equal true
      end

      it 'should not be set to true if bundler is enabled' do
        subject.new(:bundler => true, :rubygems => true).rubygems?.must_equal false
      end
    end

    describe 'drb' do
      it 'default should be false' do
        subject.new.drb?.must_equal false
      end

      it 'should be set' do
        subject.new(:drb => true).drb?.must_equal true
      end
    end

    describe 'zeus' do
      it 'default should be false' do
        subject.new.zeus?.must_equal false
      end

      it 'should be settable using a boolean' do
        subject.new(:zeus => true).zeus?.must_equal true
      end

      it 'should be settable using a string which represents the command to send to zeus' do
        subject.new(:zeus => 'blah').zeus?.must_equal true
      end
    end

    describe 'spring' do
      it 'default should be false' do
        subject.new.spring?.must_equal false
      end

      it 'should be settable using a boolean' do
        subject.new(:spring => true).spring?.must_equal true
      end
    end
  end

  describe 'run' do
    before(:each) do
      Dir.stubs(:pwd).returns(fixtures_path.join('empty'))
      @default_runner = File.expand_path('../../../../lib/guard/minitest/runners/default_runner.rb', __FILE__)
    end

    it 'should run with specified seed' do
      runner = subject.new(:test_folders => %w[test], :cli => '--seed 12345')
      runner.expects(:system).with(
        "ruby -I\"test\" -r ./test/test_minitest.rb -r #{@default_runner} -e '#{@minitest_autorun}' -- --seed 12345 -p"
      )
      runner.run(['test/test_minitest.rb'])
    end

    it 'should run in verbose mode' do
      runner = subject.new(:test_folders => %w[test], :cli => '--verbose')
      runner.expects(:system).with(
        "ruby -I\"test\" -r ./test/test_minitest.rb -r #{@default_runner} -e '#{@minitest_autorun}' -- --verbose -p"
      )
      runner.run(['test/test_minitest.rb'])
    end

    describe 'in empty folder' do

      before(:each) do
        Dir.stubs(:pwd).returns(fixtures_path.join('empty'))
      end

      it 'should run without bundler and rubygems' do
        runner = subject.new(:test_folders => %w[test])
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "ruby -I\"test\" -r ./test/test_minitest.rb -r #{@default_runner} -e '#{@minitest_autorun}' -- -p"
        )
        runner.run(['test/test_minitest.rb'])
      end

      it 'should run without bundler but rubygems' do
        runner = subject.new(:test_folders => %w[test], :rubygems => true)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "ruby -I\"test\" -r rubygems -r ./test/test_minitest.rb -r #{@default_runner} -e '#{@minitest_autorun}' -- -p"
        )
        runner.run(['test/test_minitest.rb'])
      end

    end

    describe 'in bundler folder' do
      before(:each) do
        Dir.stubs(:pwd).returns(fixtures_path.join('bundler'))
      end

      it 'should run with bundler but not rubygems' do
        runner = subject.new(:test_folders => %w[test], :bundler => true, :rubygems => false)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "bundle exec ruby -I\"test\" -r bundler/setup -r ./test/test_minitest.rb -r #{@default_runner} -e '#{@minitest_autorun}' -- -p"
        )
        runner.run(['test/test_minitest.rb'])
      end

      it 'should run without bundler but rubygems' do
        runner = subject.new(:test_folders => %w[test], :bundler => false, :rubygems => true)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "ruby -I\"test\" -r rubygems -r ./test/test_minitest.rb -r #{@default_runner} -e '#{@minitest_autorun}' -- -p"
        )
        runner.run(['test/test_minitest.rb'], :bundler => false, :rubygems => true)
      end

      it 'should run without bundler and rubygems' do
        runner = subject.new(:test_folders => %w[test], :bundler => false, :rubygems => false)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "ruby -I\"test\" -r ./test/test_minitest.rb -r #{@default_runner} -e '#{@minitest_autorun}' -- -p"
        )
        runner.run(['test/test_minitest.rb'], :bundler => false, :rubygems => false)
      end

    end

    describe 'zeus' do
      it 'should run with default zeus command' do
        runner = subject.new(:test_folders => %w[test], :zeus => true)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "zeus test ./test/test_minitest.rb"
        )
        runner.run(['test/test_minitest.rb'], :zeus => true)
      end

      it 'should run with custom zeus command' do
        runner = subject.new(:test_folders => %w[test], :zeus => 'abcxyz')
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "zeus abcxyz ./test/test_minitest.rb"
        )
        runner.run(['test/test_minitest.rb'], :zeus => 'abcxyz')
      end
    end

    describe 'spring' do
      it 'should run with default spring command' do
        runner = subject.new(:test_folders => %w[test], :spring => true)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "spring testunit ./test/test_minitest.rb"
        )
        runner.run(['test/test_minitest.rb'], :spring => true)
      end
    end

    describe 'drb' do
      it 'should run with drb' do
        runner = subject.new(:test_folders => %w[test], :drb => true)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "testdrb -Itest ./test/test_minitest.rb"
        )
        runner.run(['test/test_minitest.rb'], :drb => true)
      end
    end
  end
end
