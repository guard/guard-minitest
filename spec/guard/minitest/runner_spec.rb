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

    describe 'drb' do

      it 'default should be false' do
        subject.new.drb?.must_equal false
      end

      it 'should be set' do
        subject.new(:drb => true).drb?.must_equal true
      end

    end
  end

  describe 'run' do

    before(:each) do
      Dir.stubs(:pwd).returns(fixtures_path.join('empty'))
      @default_runner = File.expand_path('../../../../lib/guard/minitest/runners/default_runner.rb', __FILE__)
    end

    it 'should run with specified seed' do
      runner = subject.new(:seed => 12345)
      Guard::UI.expects(:info)
      runner.expects(:system).with(
        "ruby -Itest -Ispec -r ./test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' -- --seed 12345"
      )
      runner.run(['test/test_minitest.rb'])
    end

    it 'should run in verbose mode' do
      runner = subject.new(:verbose => true)
      Guard::UI.expects(:info)
      runner.expects(:system).with(
        "ruby -Itest -Ispec -r ./test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' -- --verbose"
      )
      runner.run(['test/test_minitest.rb'])
    end

    it 'should disable notification' do
      runner = subject.new(:notify => false)
      Guard::UI.expects(:info)
      runner.expects(:system).with(
        "ruby -Itest -Ispec -r ./test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=false; MiniTest::Unit.autorun' --"
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
          "ruby -Itest -Ispec -r ./test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
        )
        runner.run(['test/test_minitest.rb'])
      end

      it 'should run without bundler but rubygems' do
        runner = subject.new(:rubygems => true)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "ruby -Itest -Ispec -r rubygems -r ./test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
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
          "bundle exec ruby -Itest -Ispec -r bundler/setup -r ./test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
        )
        runner.run(['test/test_minitest.rb'])
      end

      it 'should run without bundler but rubygems' do
        runner = subject.new(:bundler => false, :rubygems => true)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "ruby -Itest -Ispec -r rubygems -r ./test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
        )
        runner.run(['test/test_minitest.rb'], :bundler => false, :rubygems => true)
      end

      it 'should run without bundler and rubygems' do
        runner = subject.new(:bundler => false, :rubygems => false)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "ruby -Itest -Ispec -r ./test/test_minitest.rb -r #{@default_runner} -e 'GUARD_NOTIFY=true; MiniTest::Unit.autorun' --"
        )
        runner.run(['test/test_minitest.rb'], :bundler => false, :rubygems => false)
      end

    end

    describe 'drb' do
      describe 'when using test_helper' do
        it 'should run with drb' do
          runner = subject.new(:drb => true)
          Guard::UI.expects(:info)
          File.expects(:exist?).with('test/test_helper.rb').returns(true)
          File.expects(:exist?).with('spec/spec_helper.rb').returns(false)
          runner.expects(:system).with(
            "testdrb -r #{File.expand_path('.')}/lib/guard/minitest/runners/default_runner.rb -e '::GUARD_NOTIFY=true' test/test_helper.rb ./test/test_minitest.rb"
          )
          runner.run(['test/test_minitest.rb'], :drb => true)
        end

        it 'should run with drb and notify=false' do
          runner = subject.new(:drb => true, :notify => false)
          Guard::UI.expects(:info)
          File.expects(:exist?).with('test/test_helper.rb').returns(true)
          File.expects(:exist?).with('spec/spec_helper.rb').returns(false)
          runner.expects(:system).with(
            "testdrb -r #{File.expand_path('.')}/lib/guard/minitest/runners/default_runner.rb -e '::GUARD_NOTIFY=false' test/test_helper.rb ./test/test_minitest.rb"
          )
          runner.run(['test/test_minitest.rb'], :drb => true)
        end
      end

      describe 'when using spec_helper' do
        it 'should run with drb' do
          runner = subject.new(:drb => true)
          Guard::UI.expects(:info)
          File.expects(:exist?).with('test/test_helper.rb').returns(false)
          File.expects(:exist?).with('spec/spec_helper.rb').returns(true)
          runner.expects(:system).with(
            "testdrb -r #{File.expand_path('.')}/lib/guard/minitest/runners/default_runner.rb -e '::GUARD_NOTIFY=true' spec/spec_helper.rb ./test/test_minitest.rb"
          )
          runner.run(['test/test_minitest.rb'], :drb => true)
        end

        it 'should run with drb and notify=false' do
          runner = subject.new(:drb => true, :notify => false)
          Guard::UI.expects(:info)
          File.expects(:exist?).with('test/test_helper.rb').returns(false)
          File.expects(:exist?).with('spec/spec_helper.rb').returns(true)
          runner.expects(:system).with(
            "testdrb -r #{File.expand_path('.')}/lib/guard/minitest/runners/default_runner.rb -e '::GUARD_NOTIFY=false' spec/spec_helper.rb ./test/test_minitest.rb"
          )
          runner.run(['test/test_minitest.rb'], :drb => true)
        end
      end
    end
  end
end
