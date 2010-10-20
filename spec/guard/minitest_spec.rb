# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest do
  subject { Guard::Minitest.new }

  describe 'start' do
    it 'should set seed option' do
      Guard::Minitest::Runner.expects(:set_seed)
      subject.start
    end
  end
end
