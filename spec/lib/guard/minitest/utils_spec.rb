require 'guard/minitest/utils'

RSpec.describe Guard::Minitest::Utils do
  context 'when guard is included first' do
    it 'loads correctly as minitest plugin' do
      code = <<-EOS
        require 'guard/minitest/utils'
      EOS

      system(*%w(bundle exec ruby -rguard -e) + [code])
    end
  end

  context 'when guard is not included' do
    it 'loads correctly as minitest plugin' do
      code = <<-EOS
        require 'guard/minitest/utils'
      EOS

      system(*%w(bundle exec ruby -e) + [code])
    end

    if !Guard::Minitest::Utils.minitest_version_gte_5?
      context 'when runner for old minitest is used' do
        it "load guard automatically" do
          code = <<-EOS
        require 'guard/minitest/runners/old_runner'
        exit 0
          EOS

          expect(system(*%w(bundle exec ruby -e) + [code])).to eq(true)
        end
      end
    end
  end
end
