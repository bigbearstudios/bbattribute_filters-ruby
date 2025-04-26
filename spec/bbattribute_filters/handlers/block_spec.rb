# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBAttributeFilters::Handlers::Block do
  describe '.new' do
    it 'should allow initalization with a symbol' do
      expect(described_class.new { true }).to be_a(described_class)
    end

    it 'should raise an exception when initalized with anything else' do
      expect { described_class.new('symbol') }.to raise_error(ArgumentError)
      expect { described_class.new([]) }.to raise_error(ArgumentError)
      expect { described_class.new({}) }.to raise_error(ArgumentError)
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end
end
