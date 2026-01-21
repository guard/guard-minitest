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
  end
end
