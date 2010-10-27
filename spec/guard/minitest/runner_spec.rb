# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest::Runner do
  subject { Guard::Minitest::Runner }

  after(:each) do
    subject.class_eval do
      @seed     = nil
      @verbose  = nil
      @notify   = nil
      @bundler  = nil
      @rubygems = nil
    end
  end

  describe 'options' do
    
    describe 'set_seed' do

      it 'should not set random seed by default' do
        subject.seed.must_be_nil
        subject.set_seed({})
        subject.seed.must_be_nil
      end

      it 'should use seed option first' do
        subject.seed.must_be_nil
        subject.set_seed(:seed => 123456789)
        subject.seed.must_equal 123456789
      end

    end

    describe 'set_verbose' do

      it 'should set verbose to false by default' do
        subject.verbose?.must_equal false
        subject.set_verbose
        subject.verbose?.must_equal false
      end

      it 'should use verbose option first' do
        subject.verbose?.must_equal false
        subject.set_verbose(:verbose => true)
        subject.verbose?.must_equal true
      end

    end

    describe 'set_notify' do

      it 'should set notify to true by default' do
        subject.notify?.must_equal true
        subject.set_notify
        subject.notify?.must_equal true
      end

      it 'should use notify option first' do
        subject.notify?.must_equal true
        subject.set_notify(:notify => false)
        subject.notify?.must_equal false
      end

    end

    describe 'set_bundler' do

      it 'should set bundler to true by default if Gemfile is present' do
        Dir.stubs(:pwd).returns(fixtures_path.join('bundler'))
        subject.bundler?.must_equal true
      end

      it 'should set bundler to false by default if Gemfile is not present' do
        Dir.stubs(:pwd).returns(fixtures_path.join('empty'))
        subject.bundler?.must_equal false
      end

      it 'should use bundler option first' do
        Dir.stubs(:pwd).returns(fixtures_path.join('bundler'))
        subject.bundler?.must_equal true
        subject.set_bundler(:bundler => false)
        subject.bundler?.must_equal false
      end

    end

    describe 'rubygems' do

      it 'should set rubygems to false by default' do
        subject.rubygems?.must_equal false
      end

      it 'should set rubygems' do
        subject.stubs(:bundler?).returns(false)
        subject.rubygems?.must_equal false
        subject.set_rubygems(:rubygems => true)
        subject.rubygems?.must_equal true
      end
 
      it 'should set rubygems to false if bundler is set to true' do
        subject.stubs(:bundler?).returns(true)
        subject.rubygems?.must_equal false
        subject.set_rubygems(:rubygems => true)
        subject.rubygems?.must_equal false
      end

    end
  end

  describe 'run' do

    before(:each) do
      @default_runner = File.expand_path('../../../../lib/guard/minitest/runners/default_runner.rb', __FILE__)
    end

    describe 'in empty folder' do

      before(:each) do
        Dir.stubs(:pwd).returns(fixtures_path.join('empty'))
      end

      it 'should run without bundler and rubygems' do
        Guard::UI.expects(:info)
        subject.expects(:system).with(
          "ruby -Itest -Ispec -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
        )
        subject.run(['test/test_minitest.rb'])
      end

      it 'should run without bundler but rubygems' do
        subject.set_rubygems(:rubygems => true)
        Guard::UI.expects(:info)
        subject.expects(:system).with(
          "ruby -Itest -Ispec -r rubygems -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
        )
        subject.run(['test/test_minitest.rb'])
      end

      it 'should run with specified seed' do
        subject.set_seed(:seed => 12345)
        Guard::UI.expects(:info)
        subject.expects(:system).with(
          "ruby -Itest -Ispec -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' -- --seed 12345"
        )
        subject.run(['test/test_minitest.rb'])
      end

      it 'should run in verbose mode' do
        subject.set_verbose(:verbose => true)
        Guard::UI.expects(:info)
        subject.expects(:system).with(
          "ruby -Itest -Ispec -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' -- --verbose"
        )
        subject.run(['test/test_minitest.rb'])
      end

      it 'should disable notification' do
        subject.set_notify(:notify => false)
        Guard::UI.expects(:info)
        subject.expects(:system).with(
          "ruby -Itest -Ispec -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=false; MiniTest::Unit.autorun' --"
        )
        subject.run(['test/test_minitest.rb'])
      end

    end

    describe 'in bundler folder' do

      before(:each) do
        Dir.stubs(:pwd).returns(fixtures_path.join('bundler'))
      end

      it 'should run with bundler but not rubygems' do
        Guard::UI.expects(:info)
        subject.expects(:system).with(
          "bundle exec ruby -Itest -Ispec -r bundler/setup -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
        )
        subject.run(['test/test_minitest.rb'])
      end

      it 'should run without bundler but rubygems' do
        subject.set_bundler(:bundler => false)
        subject.set_rubygems(:rubygems => true)
        Guard::UI.expects(:info)
        subject.expects(:system).with(
          "ruby -Itest -Ispec -r rubygems -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
        )
        subject.run(['test/test_minitest.rb'])
      end

      it 'should run without bundler and rubygems' do
        subject.set_bundler(:bundler => false)
        Guard::UI.expects(:info)
        subject.expects(:system).with(
          "ruby -Itest -Ispec -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
        )
        subject.run(['test/test_minitest.rb'])
      end

      it 'should run with specified seed' do
        subject.set_seed(:seed => 12345)
        Guard::UI.expects(:info)
        subject.expects(:system).with(
          "bundle exec ruby -Itest -Ispec -r bundler/setup -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' -- --seed 12345"
        )
        subject.run(['test/test_minitest.rb'])
      end

      it 'should run in verbose mode' do
        subject.set_verbose(:verbose => true)
        Guard::UI.expects(:info)
        subject.expects(:system).with(
          "bundle exec ruby -Itest -Ispec -r bundler/setup -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' -- --verbose"
        )
        subject.run(['test/test_minitest.rb'])
      end

      it 'should disable notification' do
        subject.set_notify(:notify => false)
        Guard::UI.expects(:info)
        subject.expects(:system).with(
          "bundle exec ruby -Itest -Ispec -r bundler/setup -r test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=false; MiniTest::Unit.autorun' --"
        )
        subject.run(['test/test_minitest.rb'])
      end

    end

  end
end
