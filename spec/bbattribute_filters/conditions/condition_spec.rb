# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBAttributeFilters::Conditions::Condition do
  describe '.new' do
    it 'should allow initalization with a valid type and condition' do
      expect(described_class.new(:if, :symbol)).to be_a(described_class)
      expect(described_class.new(:if, proc { true })).to be_a(described_class)

      expect(described_class.new(:none, :symbol)).to be_a(described_class)
      expect(described_class.new(:none, proc { true })).to be_a(described_class)

      expect(described_class.new(:unless, :symbol)).to be_a(described_class)
      expect(described_class.new(:unless, proc { true })).to be_a(described_class)
    end

    it 'should raise an exception when initalized with anything else' do
      expect { described_class.new('symbol') }.to raise_error(ArgumentError)
      expect { described_class.new([]) }.to raise_error(ArgumentError)
      expect { described_class.new({}) }.to raise_error(ArgumentError)
      expect { described_class.new(:not_valid, :symbol) }.to raise_error(ArgumentError)
    end
  end

  describe '.evaluate' do
    subject { described_class.new(:none, :evaluate_by_symbol) }
    let(:evaluator) { {} }

    before do
      allow(evaluator).to receive(:evaluate_by_symbol)
      subject.evaluate(evaluator)
    end

    it 'should call evaluate on the symbol provided' do
      expect(evaluator).to have_received(:evaluate_by_symbol)
    end
  end

  describe '.include?' do
    subject { described_class.new(:if, :symbol) }

    it 'should return true' do
      expect(subject.include?(nil)).to be true
    end
  end

  describe '.exclude?' do
    subject { described_class.new(:if, :symbol) }

    it 'should return false' do
      expect(subject.exclude?(nil)).to be false
    end
  end
end
