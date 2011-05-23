# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest::Runner do
  subject { Guard::Minitest::Runner }

  describe 'options' do

    describe 'seed' do

      it 'default should be nil' do
        subject.new.seed.must_be_nil
      end

      it 'should be set' do
        subject.new(:seed => 123456789).seed.must_equal 123456789
      end

    end

    describe 'verbose' do

      it 'default should should be false' do
        subject.new.verbose?.must_equal false
      end

      it 'should be set' do
        subject.new(:verbose => true).verbose?.must_equal true
      end

    end

    describe 'notify' do

      it 'default should be true' do
        subject.new.notify?.must_equal true
      end

      it 'should be set' do
        subject.new(:notify => false).notify?.must_equal false
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

    describe 'version' do
      it 'default should be 1 if minitest 1 is loaded' do
        MiniTest::Unit::VERSION.replace('1.7.2')
        subject.new.version.must_equal 1
      end

      it 'default should be 2 if minitest 2 is loaded' do
        MiniTest::Unit::VERSION.replace('2.1.0')
        subject.new.version.must_equal 2
      end

      it 'default should be 2 if minitest is not loaded' do
        MiniTest::Unit.send(:remove_const, :VERSION)
        subject.new.version.must_equal 2
      end

      it 'should be forced to 1 (useful if minitest is not loaded with guard)' do
        subject.new(:version => 1).version.must_equal 1
      end

      it 'should be forced to 2 (useful if minitest is not loaded with guard)' do
        subject.new(:version => 2).version.must_equal 2
      end

    end
  end

  describe 'run' do

    before(:each) do
      Dir.stubs(:pwd).returns(fixtures_path.join('empty'))
      @version_1_runner = File.expand_path('../../../../lib/guard/minitest/runners/version_1_runner.rb', __FILE__)
      @version_2_runner = File.expand_path('../../../../lib/guard/minitest/runners/version_2_runner.rb', __FILE__)
      @default_runner   = File.expand_path("../../../../lib/guard/minitest/runners/version_#{subject.new.version}_runner.rb", __FILE__)
    end

    it 'should run version 1 runner if minitest 1 is used' do
      runner = subject.new(:version => 1)
      Guard::UI.expects(:info)
      runner.expects(:system).with(
        "ruby -Itest -Ispec -r test/test_minitest.rb -r #{@version_1_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
      )
      runner.run(['test/test_minitest.rb'])
    end

    it 'should run version 2 runner if minitest 2 is used' do
      runner = subject.new(:version => 2)
      Guard::UI.expects(:info)
      runner.expects(:system).with(
        "ruby -Itest -Ispec -r test/test_minitest.rb -r #{@version_2_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
      )
      runner.run(['test/test_minitest.rb'])
    end

    it 'should run version 2 runner by default' do
      runner = subject.new(:version => nil)
      Guard::UI.expects(:info)
      runner.expects(:system).with(
        "ruby -Itest -Ispec -r test/test_minitest.rb -r #{@version_2_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
      )
      runner.run(['test/test_minitest.rb'])
    end

    it 'should run with specified seed' do
      runner = subject.new(:seed => 12345)
      Guard::UI.expects(:info)
      runner.expects(:system).with(
        "ruby -Itest -Ispec -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' -- --seed 12345"
      )
      runner.run(['test/test_minitest.rb'])
    end

    it 'should run in verbose mode' do
      runner = subject.new(:verbose => true)
      Guard::UI.expects(:info)
      runner.expects(:system).with(
        "ruby -Itest -Ispec -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' -- --verbose"
      )
      runner.run(['test/test_minitest.rb'])
    end

    it 'should disable notification' do
      runner = subject.new(:notify => false)
      Guard::UI.expects(:info)
      runner.expects(:system).with(
        "ruby -Itest -Ispec -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=false; MiniTest::Unit.autorun' --"
      )
      runner.run(['test/test_minitest.rb'])
    end

    describe 'in empty folder' do

      before(:each) do
        Dir.stubs(:pwd).returns(fixtures_path.join('empty'))
      end

      it 'should run without bundler and rubygems' do
        runner = subject.new
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "ruby -Itest -Ispec -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
        )
        runner.run(['test/test_minitest.rb'])
      end

      it 'should run without bundler but rubygems' do
        runner = subject.new(:rubygems => true)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "ruby -Itest -Ispec -r rubygems -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
        )
        runner.run(['test/test_minitest.rb'])
      end

    end

    describe 'in bundler folder' do

      before(:each) do
        Dir.stubs(:pwd).returns(fixtures_path.join('bundler'))
      end

      it 'should run with bundler but not rubygems' do
        runner = subject.new(:bundler => true, :rubygems => false)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "bundle exec ruby -Itest -Ispec -r bundler/setup -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
        )
        runner.run(['test/test_minitest.rb'])
      end

      it 'should run without bundler but rubygems' do
        runner = subject.new(:bundler => false, :rubygems => true)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "ruby -Itest -Ispec -r rubygems -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
        )
        runner.run(['test/test_minitest.rb'], :bundler => false, :rubygems => true)
      end

      it 'should run without bundler and rubygems' do
        runner = subject.new(:bundler => false, :rubygems => false)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "ruby -Itest -Ispec -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
        )
        runner.run(['test/test_minitest.rb'], :bundler => false, :rubygems => false)
      end

    end

  end
end
