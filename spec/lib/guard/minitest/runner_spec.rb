require 'spec_helper'

describe Guard::Minitest::Runner do
  subject { Guard::Minitest::Runner }

  before do
    @old_runner = Guard::Minitest::Utils.minitest_version_gte_5? ? '' : " #{File.expand_path('../../../../../lib/guard/minitest/runners/old_runner.rb', __FILE__)}"
    @require_old_runner = Guard::Minitest::Utils.minitest_version_gte_5? ? '' : " -r#{@old_runner}"
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

      it 'is settable using a string which represents the command to send to spring' do
        subject.new(spring: 'rake test').spring?.must_equal true
      end
    end

    describe 'all_after_pass' do
      it 'defaults to false' do
        subject.new.all_after_pass?.must_equal false
      end

      it 'is settable using a boolean' do
        subject.new(all_after_pass: true).all_after_pass?.must_equal true
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

        runner.run(['test/test_minitest.rb'])
      end

      it 'runs without bundler and rubygems' do
        runner = subject.new(bundler: false, rubygems: false)

        Guard::UI.expects(:info)
        runner.expects(:system).with(
          "ruby -I\"test\" -I\"spec\" -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
        )

        runner.run(['test/test_minitest.rb'])
      end
    end

    describe 'all_after_pass' do
      describe 'when set' do
        it 'runs all tests after success' do
          runner = subject.new(all_after_pass: true)
          runner.stubs(:system).returns(true)
          runner.expects(:run_all)

          runner.run(['test/test_minitest.rb'])
        end

        it 'does not run all tests after failure' do
          runner = subject.new(all_after_pass: true)
          runner.stubs(:system).returns(false)
          runner.expects(:run_all).never

          runner.run(['test/test_minitest.rb'])
        end
      end

      describe 'when unset' do
        it 'does not run all tests again after success' do
          runner = subject.new(all_after_pass: false)
          runner.stubs(:system).returns(true)
          runner.expects(:run_all).never

          runner.run(['test/test_minitest.rb'])
        end
      end
    end

    describe 'zeus' do
      it 'runs with default zeus command' do
        runner = subject.new(zeus: true)

        Guard::UI.expects(:info)
        runner.expects(:system).with('zeus test ./test/test_minitest.rb')

        runner.run(['test/test_minitest.rb'])
      end

      it 'runs with custom zeus command' do
        runner = subject.new(zeus: 'abcxyz')

        Guard::UI.expects(:info)
        runner.expects(:system).with('zeus abcxyz ./test/test_minitest.rb')

        runner.run(['test/test_minitest.rb'])
      end

      describe 'notifications' do
        it 'provides success notification when the zeus exit status is 0' do
          runner = subject.new(zeus: true)

          runner.expects(:system).with('zeus test ./test/test_minitest.rb').returns(true)
          Guard::Notifier.expects(:notify).with('Running: test/test_minitest.rb', title: 'Minitest results', image: :success)

          runner.run(['test/test_minitest.rb'])
        end

        it 'provides failed notification when the zeus exit status is non-zero or the command failed' do
          runner = subject.new(zeus: true)

          runner.expects(:system).with('zeus test ./test/test_minitest.rb').returns(false)
          Guard::Notifier.expects(:notify).with('Running: test/test_minitest.rb', title: 'Minitest results', image: :failed)

          runner.run(['test/test_minitest.rb'])
        end
      end
    end

    describe 'spring' do
      it 'runs with default spring command' do
        runner = subject.new(spring: true)

        Guard::UI.expects(:info)
        runner.expects(:system).with("spring testunit#{@old_runner} test/test_minitest.rb")

        runner.run(['test/test_minitest.rb'])
      end

      it 'runs with a clean environment' do
        runner = subject.new(spring: true)

        Guard::UI.expects(:info)
        Bundler.expects(:with_clean_env).yields
        runner.expects(:system).with("spring testunit#{@old_runner} test/test_minitest.rb")

        runner.run(['test/test_minitest.rb'])
      end

      it 'runs with custom spring command' do
        runner = subject.new(spring: 'rake test')

        Guard::UI.expects(:info)
        runner.expects(:system).with("spring rake test test/test_minitest.rb")

        runner.run(['test/test_minitest.rb'])
      end

      it 'runs default spring command with cli' do
        runner = subject.new(spring: true, cli: '--seed 12345 --verbose')

        Guard::UI.expects(:info)
        runner.expects(:system).with("spring testunit#{@old_runner} test/test_minitest.rb -- --seed 12345 --verbose")

        runner.run(['test/test_minitest.rb'])
      end

      it 'runs custom spring command with cli' do
        runner = subject.new(spring: 'rake test', cli: '--seed 12345 --verbose')

        Guard::UI.expects(:info)
        runner.expects(:system).with("spring rake test test/test_minitest.rb -- --seed 12345 --verbose")

        runner.run(['test/test_minitest.rb'])
      end

      it 'provides success notification when the spring exit status is 0' do
        runner = subject.new(spring: true)

        runner.expects(:system).with("spring testunit#{@old_runner} test/test_minitest.rb").returns(true)
        Guard::Notifier.expects(:notify).with('Running: test/test_minitest.rb', title: 'Minitest results', image: :success)

        runner.run(['test/test_minitest.rb'])
      end

      it 'provides failed notification when the spring exit status is non-zero or the command failed' do
        runner = subject.new(spring: true)

        runner.expects(:system).with("spring testunit#{@old_runner} test/test_minitest.rb").returns(false)
        Guard::Notifier.expects(:notify).with('Running: test/test_minitest.rb', title: 'Minitest results', image: :failed)

        runner.run(['test/test_minitest.rb'])
      end
    end

    describe 'drb' do
      it 'should run with drb' do
        runner = subject.new(drb: true)

        Guard::UI.expects(:info)
        runner.expects(:system).with('testdrb ./test/test_minitest.rb')

        runner.run(['test/test_minitest.rb'])
      end
    end
  end

  describe 'run_all' do
    it 'runs all tests' do
      paths = %w[test/test_minitest_1.rb test/test_minitest_2.rb]
      runner = subject.new
      runner.inspector.stubs(:clean_all).returns(paths)
      runner.expects(:run).with(paths, { all: true }).returns(true)

      runner.run_all.must_equal true
    end
  end

  describe 'run_on_modifications' do
    let(:runner) { subject.new }

    before do
      @paths = %w[test/test_minitest_1.rb test/test_minitest_2.rb]
      Dir.stubs(:pwd).returns(fixtures_path.join('empty'))
      Dir.stubs(:[]).returns(@paths)
    end

    describe 'when all paths are passed' do
      before do
        runner.inspector.stubs(:clean).returns(@paths)
      end

      it 'runs minitest in all paths' do
        runner.expects(:run).with(@paths, all: true).returns(true)

        runner.run_on_modifications(@paths).must_equal true
      end

      it 'does not run all tests again after success even when all_after_pass is enabled' do
        new_runner = subject.new(all_after_pass: true)
        new_runner.stubs(:system).returns(true)
        new_runner.expects(:run_all).never

        new_runner.run_on_modifications(@paths).must_equal true
      end
    end

    describe 'when not all paths are passed' do
      before do
        runner.inspector.stubs(:clean).returns(['test/test_minitest_1.rb'])
      end

      it 'runs minitest in paths' do
        runner.expects(:run).with(['test/test_minitest_1.rb'], all: false).returns(true)

        runner.run_on_modifications(@paths).must_equal true
      end

      it 'runs all tests again after success if all_after_pass enabled' do
        new_runner = subject.new(all_after_pass: true)
        new_runner.stubs(:system).returns(true)
        new_runner.expects(:run).with(@paths, all: true).returns(true)

        new_runner.run_on_modifications(@paths).must_equal true
      end
    end
  end

  describe 'run_on_additions' do
    it 'clears the test file cache and runs minitest for the new path' do
      runner = subject.new
      runner.inspector.stubs(:clean).with(['test/guard/minitest/test_new.rb']).returns(['test/guard/minitest/test_new.rb'])
      runner.inspector.expects(:clear_memoized_test_files)

      runner.run_on_additions(['test/guard/minitest/test_new.rb']).must_equal true
    end
  end

  describe 'run_on_removals' do
    it 'clears the test file cache and does not run minitest' do
      runner = subject.new
      runner.inspector.stubs(:clean).with(['test/guard/minitest/test_deleted.rb']).returns(['test/guard/minitest/test_deleted.rb'])
      runner.inspector.expects(:clear_memoized_test_files)
      runner.expects(:run).never

      runner.run_on_removals(['test/guard/minitest/test_deleted.rb'])
    end
  end
end
