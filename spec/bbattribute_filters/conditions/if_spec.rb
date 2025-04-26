# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBAttributeFilters::Conditions::If do
  describe '.new' do
    it 'should allow initalization with a valid type and condition' do
      expect(described_class.new(:symbol)).to be_a(described_class)
      expect(described_class.new(proc { true })).to be_a(described_class)
    end

    it 'should raise an exception when initalized with anything else' do
      expect { described_class.new('symbol') }.to raise_error(ArgumentError)
      expect { described_class.new([]) }.to raise_error(ArgumentError)
      expect { described_class.new({}) }.to raise_error(ArgumentError)
      expect { described_class.new(:not_valid, :symbol) }.to raise_error(ArgumentError)
    end
  end

  describe '.evaluate' do
    subject { described_class.new(:evaluate_by_symbol) }
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
    subject { described_class.new(:symbol) }

    context 'with a true proc' do
      subject { described_class.new(proc { true }) }

      it 'should return false' do
        expect(subject.include?(nil)).to be true
      end
    end

    context 'with a false proc' do
      subject { described_class.new(proc { false }) }

      it 'should return false' do
        expect(subject.include?(nil)).to be false
      end
    end

    context 'with a symboled method which returns true' do
      subject { described_class.new(:return_true) }
      let(:evaluator) { {} }

      before do
        allow(evaluator).to receive(:return_true).and_return(true)
        subject.evaluate(evaluator)
      end

      it 'should return false' do
        expect(subject.include?(evaluator)).to be true
      end
    end

    context 'with a symboled method which returns false' do
      subject { described_class.new(:return_false) }
      let(:evaluator) { {} }

      before do
        allow(evaluator).to receive(:return_false).and_return(false)
        subject.evaluate(evaluator)
      end

      it 'should return true' do
        expect(subject.include?(evaluator)).to be false
      end
    end
  end

  describe '.exclude?' do
    subject { described_class.new(:symbol) }

    context 'with a true proc' do
      subject { described_class.new(proc { true }) }

      it 'should return false' do
        expect(subject.exclude?(nil)).to be false
      end
    end

    context 'with a false proc' do
      subject { described_class.new(proc { false }) }

      it 'should return false' do
        expect(subject.exclude?(nil)).to be true
      end
    end

    context 'with a symboled method which returns true' do
      subject { described_class.new(:return_true) }
      let(:evaluator) { {} }

      before do
        allow(evaluator).to receive(:return_true).and_return(true)
        subject.evaluate(evaluator)
      end

      it 'should return false' do
        expect(subject.exclude?(evaluator)).to be false
      end
    end

    context 'with a symboled method which returns false' do
      subject { described_class.new(:return_false) }
      let(:evaluator) { {} }

      before do
        allow(evaluator).to receive(:return_false).and_return(false)
        subject.evaluate(evaluator)
      end

      it 'should return true' do
        expect(subject.exclude?(evaluator)).to be true
      end
    end
  end
end
