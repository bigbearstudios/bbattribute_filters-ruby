# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBAttributeFilters::Handlers::Evaluation do
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

    before do
      allow(evaluator).to receive(:evaluate_attribute)
      subject.evaluate(evaluator)
    end

    it 'should call the evaluator with the symbol' do
      expect(evaluator).to have_received(:evaluate_attribute).with(:symbol)
    end
  end
end
