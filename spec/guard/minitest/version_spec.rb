# encoding: utf-8
require 'spec_helper'

describe Guard::MinitestVersion do

  describe 'VERSION' do
    it 'is the current version' do
      Guard::MinitestVersion::VERSION.must_equal '1.0.0.rc.2'
    end
  end

end
