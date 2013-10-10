# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest::Runner do
  subject { Guard::Minitest::Runner }

  before do
    @old_runner = ::MiniTest::Unit::VERSION =~ /^5/ ? '' : " #{File.expand_path('../../../../lib/guard/minitest/runners/old_runner.rb', __FILE__)}"
    @require_old_runner = ::MiniTest::Unit::VERSION =~ /^5/ ? '' : " -r#{@old_runner}"
  end

  describe 'options' do

    describe 'cli_options' do
      it 'defaults to empty string' do
        subject.new.cli_options.must_equal []
      end

      it 'is set with \'cli\'' do
        subject.new(cli: '--test').cli_options.must_equal ['--test']
      end
    end

    describe 'deprecated options' do
      describe 'seed' do
        it 'sets cli options' do
          Guard::UI.expects(:info).with('DEPRECATION WARNING: The :seed option is deprecated. Pass standard command line argument "--seed" to Minitest with the :cli option.')

          subject.new(seed: 123456789).cli_options.must_equal ['--seed 123456789']
        end
      end

      describe 'verbose' do
        it 'sets cli options' do
          Guard::UI.expects(:info).with('DEPRECATION WARNING: The :verbose option is deprecated. Pass standard command line argument "--verbose" to Minitest with the :cli option.')

          subject.new(verbose: true).cli_options.must_equal ['--verbose']
        end
      end
    end

    describe 'bundler' do
      it 'defaults to true if Gemfile exist' do
        Dir.stubs(:pwd).returns(fixtures_path.join('bundler'))

        subject.new.bundler?.must_equal true
      end

      it 'defaults to false if Gemfile don\'t exist' do
        Dir.stubs(:pwd).returns(fixtures_path.join('empty'))

        subject.new.bundler?.must_equal false
      end

      it 'is forced to false' do
        Dir.stubs(:pwd).returns(fixtures_path.join('bundler'))

        subject.new(bundler: false).bundler?.must_equal false
      end

      it 'is forced to false if spring is enabled' do
        Dir.stubs(:pwd).returns(fixtures_path.join('bundler'))

        subject.new(spring: true).bundler?.must_equal false
      end
    end

    describe 'rubygems' do
      it 'defaults to false if Gemfile exist' do
        Dir.stubs(:pwd).returns(fixtures_path.join('bundler'))

        subject.new.rubygems?.must_equal false
      end

      it 'defaults to false if Gemfile don\'t exist' do
        Dir.stubs(:pwd).returns(fixtures_path.join('empty'))

        subject.new.rubygems?.must_equal false
      end

      it 'is true if bundler is disabled' do
        subject.new(bundler: false, rubygems: true).rubygems?.must_equal true
      end

      it 'is false if bundler is enabled' do
        subject.new(bundler: true, rubygems: true).rubygems?.must_equal false
      end
    end

    describe 'drb' do
      it 'defaults to false' do
        subject.new.drb?.must_equal false
      end

      it 'is settable using a boolean' do
        subject.new(drb: true).drb?.must_equal true
      end
    end

    describe 'zeus' do
      it 'defaults to false' do
        subject.new.zeus?.must_equal false
      end

      it 'is settable using a boolean' do
        subject.new(zeus: true).zeus?.must_equal true
      end

      it 'is settable using a string which represents the command to send to zeus' do
        subject.new(zeus: 'blah').zeus?.must_equal true
      end
    end

    describe 'spring' do
      it 'defaults to false' do
        subject.new.spring?.must_equal false
      end

      it 'is settable using a boolean' do
        subject.new(spring: true).spring?.must_equal true
      end
    end
  end

  describe 'run' do
    before do
      Dir.stubs(:pwd).returns(fixtures_path.join('empty'))
    end

    it 'passes :cli arguments' do
      runner = subject.new(cli: '--seed 12345 --verbose')
      runner.expects(:system).with(
        "ruby -I\"test\" -I\"spec\" -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" -- --seed 12345 --verbose"
      )

      runner.run(['test/test_minitest.rb'])
    end

    it 'runs with specified directories included' do
      runner = subject.new(include: %w[lib app])
      runner.expects(:system).with(
        "ruby -I\"test\" -I\"spec\" -I\"lib\" -I\"app\" -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
      )

      runner.run(['test/test_minitest.rb'])
    end

    describe 'in empty folder' do

      before do
        Dir.stubs(:pwd).returns(fixtures_path.join('empty'))
      end

      it 'runs without bundler and rubygems' do
        runner = subject.new
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "ruby -I\"test\" -I\"spec\" -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
        )

        runner.run(['test/test_minitest.rb'])
      end

      it 'runs without bundler but rubygems' do
        runner = subject.new(rubygems: true)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "ruby -I\"test\" -I\"spec\" -r rubygems -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
        )

        runner.run(['test/test_minitest.rb'])
      end

    end

    describe 'in bundler folder' do
      before do
        Dir.stubs(:pwd).returns(fixtures_path.join('bundler'))
      end

      it 'should run with bundler but not rubygems' do
        runner = subject.new(bundler: true, rubygems: false)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "bundle exec ruby -I\"test\" -I\"spec\" -r bundler/setup -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
        )

        runner.run(['test/test_minitest.rb'])
      end

      it 'runs without bundler but rubygems' do
        runner = subject.new(bundler: false, rubygems: true)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "ruby -I\"test\" -I\"spec\" -r rubygems -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
        )

        runner.run(['test/test_minitest.rb'], bundler: false, rubygems: true)
      end

      it 'runs without bundler and rubygems' do
        runner = subject.new(bundler: false, rubygems: false)
        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "ruby -I\"test\" -I\"spec\" -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
        )

        runner.run(['test/test_minitest.rb'], bundler: false, rubygems: false)
      end

    end

    describe 'zeus' do
      it 'runs with default zeus command' do
        runner = subject.new(zeus: true)
        Guard::UI.expects(:info)
        runner.expects(:system).with('zeus test ./test/test_minitest.rb')

        runner.run(['test/test_minitest.rb'], zeus: true)
      end

      it 'runs with custom zeus command' do
        runner = subject.new(zeus: 'abcxyz')
        Guard::UI.expects(:info)
        runner.expects(:system).with('zeus abcxyz ./test/test_minitest.rb')

        runner.run(['test/test_minitest.rb'], zeus: 'abcxyz')
      end

      describe 'notifications' do
        it 'provides success notification when the zeus exit status is 0' do
          runner = subject.new(zeus: true)

          runner.expects(:system).with('zeus test ./test/test_minitest.rb').returns(true)
          Guard::Notifier.expects(:notify).with('Running: test/test_minitest.rb', title: 'Minitest results', image: :success)
          runner.run(['test/test_minitest.rb'], zeus: true)
        end

        it 'provides failed notification when the zeus exit status is non-zero or the command failed' do
          runner = subject.new(zeus: true)

          runner.expects(:system).with('zeus test ./test/test_minitest.rb').returns(false)
          Guard::Notifier.expects(:notify).with('Running: test/test_minitest.rb', title: 'Minitest results', image: :failed)
          runner.run(['test/test_minitest.rb'], zeus: true)

          runner = subject.new(test_folders: %w[test], zeus: true)

          runner.expects(:system).with('zeus test ./test/test_minitest.rb').returns(false)
          Guard::Notifier.expects(:notify).with('Running: test/test_minitest.rb', title: 'Minitest results', image: :failed)
          runner.run(['test/test_minitest.rb'], zeus: true)
        end

        it 'provides success notification when the spring exit status is 0' do
          runner = subject.new(spring: true)

          runner.expects(:system).with("spring testunit#{@old_runner} ./test/test_minitest.rb").returns(true)
          Guard::Notifier.expects(:notify).with('Running: test/test_minitest.rb', title: 'Minitest results', image: :success)
          runner.run(['test/test_minitest.rb'], spring: true)
        end

        it 'provides failed notification when the spring exit status is non-zero or the command failed' do
          runner = subject.new(spring: true)

          runner.expects(:system).with("spring testunit#{@old_runner} ./test/test_minitest.rb").returns(false)
          Guard::Notifier.expects(:notify).with('Running: test/test_minitest.rb', title: 'Minitest results', image: :failed)
          runner.run(['test/test_minitest.rb'], spring: true)

          runner = subject.new(spring: true)

          runner.expects(:system).with("spring testunit#{@old_runner} ./test/test_minitest.rb").returns(false)
          Guard::Notifier.expects(:notify).with('Running: test/test_minitest.rb', title: 'Minitest results', image: :failed)
          runner.run(['test/test_minitest.rb'], spring: true)
        end
      end
    end

    describe 'spring' do
      it 'runs with default spring command' do
        runner = subject.new(spring: true)
        Guard::UI.expects(:info)
        runner.expects(:system).with("spring testunit#{@old_runner} ./test/test_minitest.rb")

        runner.run(['test/test_minitest.rb'], spring: true)
      end

      it 'runs with a clean environment' do
        runner = subject.new(spring: true)
        Guard::UI.expects(:info)
        Bundler.expects(:with_clean_env).yields
        runner.expects(:system).with("spring testunit#{@old_runner} ./test/test_minitest.rb")

        runner.run(['test/test_minitest.rb'], spring: true)
      end
    end

    describe 'drb' do
      it 'should run with drb' do
        runner = subject.new(drb: true)
        Guard::UI.expects(:info)
        runner.expects(:system).with('testdrb ./test/test_minitest.rb')

        runner.run(['test/test_minitest.rb'], drb: true)
      end
    end
  end
end
