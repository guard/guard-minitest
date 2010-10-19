# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest do
  subject { Guard::Minitest.new }

  describe 'start' do
    it 'should set seed option' do
      subject.start
      Guard::Minitest::Runner.seed.wont_be_nil
    end
  end
end
