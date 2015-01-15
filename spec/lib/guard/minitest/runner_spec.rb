require 'guard/minitest/runner'
require 'guard/minitest/utils'

RSpec.describe Guard::Minitest::Runner do
  let(:options) { {} }
  subject { described_class.new(options) }

  before do
    @old_runner = Guard::Minitest::Utils.minitest_version_gte_5? ? '' : " #{File.expand_path('../../../../../lib/guard/minitest/runners/old_runner.rb', __FILE__)}"
    @require_old_runner = Guard::Minitest::Utils.minitest_version_gte_5? ? '' : " -r#{@old_runner}"
    allow(Guard::Compat::UI).to receive(:notify)
    allow(Guard::Compat::UI).to receive(:debug)

    allow(Kernel).to receive(:system) do |*args|
      fail "stub me: Kernel.system(#{ args.map(&:inspect) * ", "})"
    end
  end

  describe 'options' do

    describe 'cli_options' do
      it 'defaults to empty string' do
        expect(subject.send(:cli_options)).to eq []
      end

      context "with cli" do
        let(:options) { { cli: '--test' } }
        it 'is set with \'cli\'' do
          expect(subject.send(:cli_options)).to eq ['--test']
        end
      end
    end

    describe 'deprecated options' do
      describe 'seed' do
        let(:options) { { seed: 123456789 } }
        it 'sets cli options' do
          expect(Guard::Compat::UI).to receive(:info).with('DEPRECATION WARNING: The :seed option is deprecated. Pass standard command line argument "--seed" to Minitest with the :cli option.')

          expect(subject.send(:cli_options)).to eq ['--seed 123456789']
        end
      end

      describe 'verbose' do
        let(:options) { { verbose: true } }
        it 'sets cli options' do
          expect(Guard::Compat::UI).to receive(:info).with('DEPRECATION WARNING: The :verbose option is deprecated. Pass standard command line argument "--verbose" to Minitest with the :cli option.')

          expect(subject.send(:cli_options)).to eq ['--verbose']
        end
      end
    end

    describe 'bundler' do
      it 'defaults to true if Gemfile exist' do
        allow(Dir).to receive(:pwd).and_return(fixtures_path.join('bundler'))

        expect(subject.send(:bundler?)).to eq true
      end

      it 'defaults to false if Gemfile don\'t exist' do
        allow(Dir).to receive(:pwd).and_return(fixtures_path.join('empty'))

        expect(subject.send(:bundler?)).to eq false
      end

      context "with bundler false" do
        let(:options) { { bundler: false } }
        it 'is forced to false' do
          allow(Dir).to receive(:pwd).and_return(fixtures_path.join('bundler'))

          expect(subject.send(:bundler?)).to eq false
        end
      end

      context "with spring" do
        let(:options) { { spring: true } }
        it 'is forced to false if spring is enabled' do
          allow(Dir).to receive(:pwd).and_return(fixtures_path.join('bundler'))

          expect(subject.send(:bundler?)).to eq false
        end
      end
    end

    describe 'rubygems' do
      it 'defaults to false if Gemfile exist' do
        allow(Dir).to receive(:pwd).and_return(fixtures_path.join('bundler'))

        expect(subject.send(:rubygems?)).to eq false
      end

      it 'defaults to false if Gemfile don\'t exist' do
        allow(Dir).to receive(:pwd).and_return(fixtures_path.join('empty'))

        expect(subject.send(:rubygems?)).to eq false
      end

      context "when bundler is disabled" do
        let(:options) { { bundler: false, rubygems: true } }
        it 'is true if bundler is disabled' do
          expect(subject.send(:rubygems?)).to eq true
        end
      end

      context "when bundler is enabled" do
        let(:options) { { bundler: true, rubygems: true } }
        it 'is false if bundler is enabled' do
          expect(subject.send(:rubygems?)).to eq false
        end
      end
    end

    describe 'drb' do
      it 'defaults to false' do
        expect(subject.send(:drb?)).to eq false
      end

      context "when set to true" do
        let(:options) { { drb: true } }
        specify { expect(subject.send(:drb?)).to eq true }
      end
    end

    describe 'zeus' do
      it 'defaults to false' do
        expect(subject.send(:zeus?)).to eq false
      end

      context 'when true' do
        let(:options) { { zeus: true } }
        specify { expect(subject.send(:zeus?)).to eq true }
      end

      context 'when string which represents the command to send to zeus' do
        let(:options) { { zeus: 'blah' } }
        specify { expect(subject.send(:zeus?)).to eq true }
      end
    end

    describe 'spring' do
      it 'defaults to false' do
        expect(subject.send(:spring?)).to eq false
      end

      context 'when true' do
        let(:options) { { spring: true } }
        specify { expect(subject.send(:spring?)).to eq true }
      end

      context 'when using a string which represents the command to send to spring' do
        let(:options) { { spring: 'rake test' } }
        specify { expect(subject.send(:spring?)).to eq true }
      end
    end

    describe 'all_after_pass' do
      it 'defaults to false' do
        expect(subject.send(:all_after_pass?)).to eq false
      end

      context 'when true' do
        let(:options) { { all_after_pass: true } }
        specify { expect(subject.send(:all_after_pass?)).to eq true }
      end
    end

    describe 'autorun' do
      it 'defaults to true' do
        expect(subject.send(:autorun?)).to eq true
      end

      context 'when false' do
        let(:options) { { autorun: false } }
        specify { expect(subject.send(:autorun?)).to eq false }
      end
    end
  end

  describe 'run' do
    before do
      allow(Dir).to receive(:pwd).and_return(fixtures_path.join('empty'))
    end

    context "when Guard is in debug mode" do
      before do
        allow(Kernel).to receive(:system) { system("true") }
        allow(Guard::Compat::UI).to receive(:error)
      end

      it "outputs command" do
        runner = described_class.new
        expect(Guard::Compat::UI).to receive(:debug).with("Running: ruby -I\"test\" -I\"spec\" -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --")
        runner.run(['test/test_minitest.rb'])
      end
    end

    context "when binary is not found" do
      before do
        allow(Kernel).to receive(:system) { nil }
        allow(Guard::Compat::UI).to receive(:error)
      end

      it "shows an error" do
        runner = described_class.new
        expect(Guard::Compat::UI).to receive(:error).with("No such file or directory - ruby -I\"test\" -I\"spec\" -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --")
        catch(:task_has_failed) { runner.run(['test/test_minitest.rb']) }
      end

      it "throw a task_has_failed symbol" do
        runner = described_class.new
        expect { runner.run(['test/test_minitest.rb']) }.to throw_symbol(:task_has_failed)
      end
    end

    it 'passes :cli arguments' do
      runner = described_class.new(cli: '--seed 12345 --verbose')

      expect(Kernel).to receive(:system).with(
        "ruby -I\"test\" -I\"spec\" -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" -- --seed 12345 --verbose"
      ) { system("true") }

      runner.run(['test/test_minitest.rb'])
    end

    it 'runs with specified directories included' do
      runner = described_class.new(include: %w[lib app])

      expect(Kernel).to receive(:system).with(
        "ruby -I\"test\" -I\"spec\" -I\"lib\" -I\"app\" -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
      ) { system("true") }

      runner.run(['test/test_minitest.rb'])
    end

    describe 'autorun disabled' do
      it 'does not require minitest/autorun' do
        runner = described_class.new(autorun: false)

        expect(Kernel).to receive(:system).with(
          "ruby -I\"test\" -I\"spec\" -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
        ) { system("true") }

        runner.run(['test/test_minitest.rb'])
      end
    end

    it 'sets env via all_env if running the full suite' do
      runner = described_class.new(all_env: {"TESTS_ALL" => true})

      expect(Kernel).to receive(:system).with(
        {"TESTS_ALL" => "true"},
        "ruby -I\"test\" -I\"spec\" -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
      ) { system("true") }

      runner.run(['test/test_minitest.rb'], all: true)
    end

    it 'allows string setting of all_env' do
      runner = described_class.new(all_env: "TESTS_ALL")

      expect(Kernel).to receive(:system).with(
        {"TESTS_ALL" => "true"},
        "ruby -I\"test\" -I\"spec\" -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
      ) { system("true") }

      runner.run(['test/test_minitest.rb'], all: true)
    end

    it 'runs with the specified environment' do
      runner = described_class.new(env: {MINITEST_TEST: "test"})

      expect(Kernel).to receive(:system).with(
        {"MINITEST_TEST" => "test"},
        "ruby -I\"test\" -I\"spec\" -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
      ) { system("true") }

      runner.run(['test/test_minitest.rb'])
    end

    it 'merges the specified environment with the all environment' do
      runner = described_class.new(env: {MINITEST_TEST: 'test', MINITEST: true}, all_env: {MINITEST_TEST: "all"})

      expect(Kernel).to receive(:system).with(
        {"MINITEST_TEST" => "all", "MINITEST" => "true"},
        "ruby -I\"test\" -I\"spec\" -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
      ) { system("true") }

      runner.run(['test/test_minitest.rb'], all: true)
    end

    describe 'in empty folder' do
      before do
        allow(Dir).to receive(:pwd).and_return(fixtures_path.join('empty'))
      end

      it 'runs without bundler and rubygems' do
        runner = described_class.new

        expect(Guard::Compat::UI).to receive(:info)
        expect(Kernel).to receive(:system).with(
          "ruby -I\"test\" -I\"spec\" -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
        ) { system("true") }

        runner.run(['test/test_minitest.rb'])
      end

      it 'runs without bundler but rubygems' do
        runner = described_class.new(rubygems: true)

        expect(Guard::Compat::UI).to receive(:info)
        expect(Kernel).to receive(:system).with(
          "ruby -I\"test\" -I\"spec\" -r rubygems -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
        ) { system("true") }

        runner.run(['test/test_minitest.rb'])
      end

    end

    describe 'in bundler folder' do
      before do
        allow(Dir).to receive(:pwd).and_return(fixtures_path.join('bundler'))
      end

      it 'should run with bundler but not rubygems' do
        runner = described_class.new(bundler: true, rubygems: false)

        expect(Guard::Compat::UI).to receive(:info)
        expect(Kernel).to receive(:system).with(
          "bundle exec ruby -I\"test\" -I\"spec\" -r bundler/setup -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
        ) { system("true") }

        runner.run(['test/test_minitest.rb'])
      end

      it 'runs without bundler but rubygems' do
        runner = described_class.new(bundler: false, rubygems: true)

        expect(Guard::Compat::UI).to receive(:info)
        expect(Kernel).to receive(:system).with(
          "ruby -I\"test\" -I\"spec\" -r rubygems -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
        ) { system("true") }

        runner.run(['test/test_minitest.rb'])
      end

      it 'runs without bundler and rubygems' do
        runner = described_class.new(bundler: false, rubygems: false)

        expect(Guard::Compat::UI).to receive(:info)
        expect(Kernel).to receive(:system).with(
          "ruby -I\"test\" -I\"spec\" -r minitest/autorun -r ./test/test_minitest.rb#{@require_old_runner} -e \"\" --"
        ) { system("true") }

        runner.run(['test/test_minitest.rb'])
      end
    end

    describe 'all_after_pass' do
      describe 'when set' do
        it 'runs all tests after success' do
          runner = described_class.new(all_after_pass: true)
          allow(Kernel).to receive(:system) { system("true") }
          expect(runner).to receive(:run_all)

          runner.run(['test/test_minitest.rb'])
        end

        it 'does not run all tests after failure' do
          runner = described_class.new(all_after_pass: true)
          allow(Kernel).to receive(:system) { system("false") }
          expect(runner).to receive(:run_all).never

          runner.run(['test/test_minitest.rb'])
        end
      end

      describe 'when unset' do
        it 'does not run all tests again after success' do
          runner = described_class.new(all_after_pass: false)
          allow(Kernel).to receive(:system) { system("true") }
          expect(runner).to receive(:run_all).never

          runner.run(['test/test_minitest.rb'])
        end
      end
    end

    describe 'zeus' do
      it 'runs with default zeus command' do
        runner = described_class.new(zeus: true)

        expect(Guard::Compat::UI).to receive(:info)
        expect(Kernel).to receive(:system).with('zeus test ./test/test_minitest.rb')  { system("true") }

        runner.run(['test/test_minitest.rb'])
      end

      it 'runs with custom zeus command' do
        runner = described_class.new(zeus: 'abcxyz')

        expect(Guard::Compat::UI).to receive(:info)
        expect(Kernel).to receive(:system).with('zeus abcxyz ./test/test_minitest.rb') { system("true") }

        runner.run(['test/test_minitest.rb'])
      end

      describe 'notifications' do
        it 'provides success notification when the zeus exit status is 0' do
          runner = described_class.new(zeus: true)

          expect(Kernel).to receive(:system).with('zeus test ./test/test_minitest.rb') { system("true") }
          expect(Guard::Compat::UI).to receive(:notify).with('Running: test/test_minitest.rb', title: 'Minitest results', image: :success)

          runner.run(['test/test_minitest.rb'])
        end

        it 'provides failed notification when the zeus exit status is non-zero or the command failed' do
          runner = described_class.new(zeus: true)

          expect(Kernel).to receive(:system).with('zeus test ./test/test_minitest.rb') { system("false") }
          expect(Guard::Compat::UI).to receive(:notify).with('Running: test/test_minitest.rb', title: 'Minitest results', image: :failed)

          runner.run(['test/test_minitest.rb'])
        end
      end
    end

    describe 'spring' do
      it 'runs with default spring command' do
        runner = described_class.new(spring: true)

        expect(Guard::Compat::UI).to receive(:info)
        expect(Kernel).to receive(:system).with("bin/rake test test/test_minitest.rb") { system("true") }

        runner.run(['test/test_minitest.rb'])
      end

      it 'runs with a clean environment' do
        runner = described_class.new(spring: true)

        expect(Guard::Compat::UI).to receive(:info)
        expect(Bundler).to receive(:with_clean_env).and_yield
        expect(Kernel).to receive(:system).with("bin/rake test test/test_minitest.rb") { system("true") }

        runner.run(['test/test_minitest.rb'])
      end

      it 'runs with custom spring command' do
        runner = described_class.new(spring: 'spring rake test')

        expect(Guard::Compat::UI).to receive(:info)
        expect(Kernel).to receive(:system).with("spring rake test test/test_minitest.rb") { system("true") }

        runner.run(['test/test_minitest.rb'])
      end

      it 'runs default spring command with cli' do
        runner = described_class.new(spring: true, cli: '--seed 12345 --verbose')

        expect(Guard::Compat::UI).to receive(:info)
        expect(Kernel).to receive(:system).with("bin/rake test test/test_minitest.rb -- --seed 12345 --verbose") { system("true") }

        runner.run(['test/test_minitest.rb'])
      end

      it 'runs custom spring command with cli' do
        runner = described_class.new(spring: 'spring rake test', cli: '--seed 12345 --verbose')

        expect(Guard::Compat::UI).to receive(:info)
        expect(Kernel).to receive(:system).with("spring rake test test/test_minitest.rb -- --seed 12345 --verbose") { system("true") }

        runner.run(['test/test_minitest.rb'])
      end

      it 'provides success notification when the spring exit status is 0' do
        runner = described_class.new(spring: true)

        expect(Kernel).to receive(:system).with("bin/rake test test/test_minitest.rb") { system("true") }
        expect(Guard::Compat::UI).to receive(:notify).with('Running: test/test_minitest.rb', title: 'Minitest results', image: :success)

        runner.run(['test/test_minitest.rb'])
      end

      it 'provides failed notification when the spring exit status is non-zero or the command failed' do
        runner = described_class.new(spring: true)

        expect(Kernel).to receive(:system).with("bin/rake test test/test_minitest.rb") { system("false") }
        expect(Guard::Compat::UI).to receive(:notify).with('Running: test/test_minitest.rb', title: 'Minitest results', image: :failed)

        runner.run(['test/test_minitest.rb'])
      end
    end

    describe 'drb' do
      it 'should run with drb' do
        runner = described_class.new(drb: true)

        expect(Guard::Compat::UI).to receive(:info)
        expect(Kernel).to receive(:system).with('testdrb ./test/test_minitest.rb') { system("true") }

        runner.run(['test/test_minitest.rb'])
      end

      it 'runs with specified directories included' do
        runner = described_class.new(drb: true, include: %w[lib app])

        expect(Kernel).to receive(:system).
          with( "testdrb -I\"lib\" -I\"app\" ./test/test_minitest.rb") { system("true") }

        runner.run(['test/test_minitest.rb'])
      end
    end

    describe 'when no paths are passed' do
      let(:runner) { described_class.new }

      it 'does not run a command' do
        expect(Kernel).to_not receive(:system)

        runner.run([])
      end

      it 'still runs all if requested' do
        expect(Kernel).to receive(:system).
          with( "ruby -I\"test\" -I\"spec\" -r minitest/autorun#{@require_old_runner} -e \"\" --") { system("true") }

        expect(runner.run([], all: true)).to eq true
      end
    end
  end

  describe 'run_all' do
    it 'runs all tests' do
      paths = %w[test/test_minitest_1.rb test/test_minitest_2.rb]
      runner = described_class.new
      allow(runner.inspector).to receive(:clean_all).and_return(paths)
      expect(runner).to receive(:run).with(paths, { all: true }).and_return(true)

      expect(runner.run_all).to eq true
    end
  end

  describe 'run_on_modifications' do
    let(:runner) { described_class.new }

    before do
      @paths = %w[test/test_minitest_1.rb test/test_minitest_2.rb]
      allow(Dir).to receive(:pwd).and_return(fixtures_path.join('empty'))
      allow(Dir).to receive(:[]).and_return(@paths)
    end

    describe 'when all paths are passed' do
      before do
        allow(runner.inspector).to receive(:clean).and_return(@paths)
      end

      it 'runs minitest in all paths' do
        expect(runner).to receive(:run).with(@paths, all: true).and_return(true)

        expect(runner.run_on_modifications(@paths)).to eq true
      end

      it 'does not run all tests again after success even when all_after_pass is enabled' do
        new_runner = described_class.new(all_after_pass: true)
        allow(Kernel).to receive(:system) { system("true") }
        expect(new_runner).to receive(:run_all).never

        expect(new_runner.run_on_modifications(@paths)).to eq true
      end
    end

    describe 'when not all paths are passed' do
      before do
        allow(runner.inspector).to receive(:clean).and_return(['test/test_minitest_1.rb'])
      end

      it 'runs minitest in paths' do
        expect(runner).to receive(:run).with(['test/test_minitest_1.rb'], all: false).and_return(true)

        expect(runner.run_on_modifications(@paths)).to eq true
      end

      it 'runs all tests again after success if all_after_pass enabled' do
        new_runner = described_class.new(all_after_pass: true)
        allow(Kernel).to receive(:system).and_return(true)
        expect(new_runner).to receive(:run).with(@paths, all: true).and_return(true)

        expect(new_runner.run_on_modifications(@paths)).to eq true
      end
    end
  end

  describe 'run_on_additions' do
    it 'clears the test file cache and runs minitest for the new path' do
      runner = described_class.new
      allow(runner.inspector).to receive(:clean).with(['test/guard/minitest/test_new.rb']).and_return(['test/guard/minitest/test_new.rb'])
      expect(runner.inspector).to receive(:clear_memoized_test_files)

      expect(runner.run_on_additions(['test/guard/minitest/test_new.rb'])).to eq true
    end
  end

  describe 'run_on_removals' do
    it 'clears the test file cache and does not run minitest' do
      runner = described_class.new
      allow(runner.inspector).to receive(:clean).with(['test/guard/minitest/test_deleted.rb']).and_return(['test/guard/minitest/test_deleted.rb'])
      expect(runner.inspector).to receive(:clear_memoized_test_files)
      expect(runner).to receive(:run).never

      runner.run_on_removals(['test/guard/minitest/test_deleted.rb'])
    end
  end

  context "when guard is not included" do
    before do
      allow(Kernel).to receive(:system).and_call_original
    end

    it "loads correctly as minitest plugin" do
      code =<<-EOS
        require 'guard/minitest/runner'
      EOS

      system(*%w(bundle exec ruby -e) + [code])
    end
  end
end
