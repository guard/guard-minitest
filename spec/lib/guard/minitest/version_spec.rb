RSpec.describe Guard::MinitestVersion do
  describe 'VERSION' do
    it 'is the current version' do
      expect(Guard::MinitestVersion::VERSION).to eq '2.3.2'
    end
  end
end
