# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBAttributeFilters::Handlers::Symbol do
  describe '.new' do
    it 'should allow initalization with a symbol' do
      expect(described_class.new(:symbol)).to be_a(described_class)
    end

    it 'should raise an exception when initalized with anything else' do
      expect { described_class.new('symbol') }.to raise_error(ArgumentError)
      expect { described_class.new([]) }.to raise_error(ArgumentError)
      expect { described_class.new({}) }.to raise_error(ArgumentError)
    end
  end

  describe '.evaluate' do
    subject { described_class.new(:symbol) }
    let(:evaluator) { {} }

    it 'should call the method represented by the symbol' do
      allow(evaluator).to receive(:symbol)

      subject.evaluate(evaluator)

      expect(evaluator).to have_received(:symbol)
    end
  end
end
