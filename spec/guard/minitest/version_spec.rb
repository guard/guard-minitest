# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest do

  describe 'VERSION' do
    it 'is the current version' do
      Guard::Minitest::VERSION.must_equal '1.0.0.beta1'
    end
  end

end
