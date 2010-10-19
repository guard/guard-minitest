# encoding: utf-8
require 'spec_helper'

describe Guard::Minitest::Runner do
  subject { Guard::Minitest::Runner }

  describe 'set_seed' do

    before(:each) do
      subject.class_eval do
        @seed = nil
      end
    end

    it 'should use seed option first' do
      subject.seed.must_be_nil
      subject.set_seed(:seed => 123456789)
      subject.seed.must_equal 123456789
    end

    it 'should set random seed by default' do
      subject.seed.must_be_nil
      subject.set_seed
      subject.seed.must_be_instance_of Fixnum
    end

  end
end
