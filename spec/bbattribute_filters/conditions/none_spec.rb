# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBAttributeFilters::Conditions::None do
  describe '.new' do
    it 'should allow initalization with a valid type and condition' do
      expect(described_class.new).to be_a(described_class)
      expect(described_class.new).to be_a(described_class)
    end
  end

  describe '.include?' do
    subject { described_class.new }

    it 'should return true' do
      expect(subject.include?(nil)).to be true
    end
  end

  describe '.exclude?' do
    subject { described_class.new }

    it 'should return false' do
      expect(subject.exclude?(nil)).to be false
    end
  end
end
