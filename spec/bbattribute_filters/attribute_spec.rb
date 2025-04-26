# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBAttributeFilters::Attribute do
  describe 'initialize' do
    context 'with name only' do
      it 'should pass validation with a name' do
        expect(described_class.new(:id)).to be_a(described_class)
      end
    end

    context 'with :if option' do
      it 'should pass validation with a name and a symbol if' do
        expect(described_class.new(:id, { if: :test })).to be_a described_class
      end

      it 'should pass validation with a name and a proc if' do
        expect(described_class.new(:id, { if: proc { true } })).to be_a described_class
      end
    end

    context 'with :unless option' do
      it 'should pass validation with a name and a symbol unless' do
        expect(described_class.new(:id, { unless: :test })).to be_a described_class
      end

      it 'should pass validation with a name and a proc unless' do
        expect(described_class.new(:id, { unless: proc { true } })).to be_a described_class
      end
    end

    context 'with invalid data' do
      it 'should fail validation with exception with no name' do
        expect { described_class.new(nil) }.to raise_error(ArgumentError)
      end

      it 'should fail validation with exception with a nil if' do
        expect { described_class.new(:id, { if: nil }) }.to raise_error(ArgumentError)
      end

      it 'should fail validation with exception with a nil unless' do
        expect { described_class.new(:id, { unless: nil }) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.condition_type' do
    it 'should return :if with a :if key' do
      expect(described_class.new(:id, { if: :test }).condition_type).to be :if
    end

    it 'should return :unless with a :unless key' do
      expect(described_class.new(:id, { unless: :test }).condition_type).to be :unless
    end

    it 'should return :none with a no :if, :unless key' do
      expect(described_class.new(:id).condition_type).to be :none
    end
  end

  class self::BooleanTestClass
    def true
      true
    end

    def false
      false
    end
  end

  describe '.include?' do
    context 'with :if option' do
      it 'should return true when Proc returns true' do
        attribute = described_class.new(:id, { if: proc { true } })
        expect(attribute.include?(Object.new)).to be true
      end

      it 'should return true when method returns true' do
        attribute = described_class.new(:id, { if: :true })
        expect(attribute.include?(self.class::BooleanTestClass.new)).to be true
      end

      it 'should return false when Proc returns false' do
        attribute = described_class.new(:id, { if: proc { false } })
        expect(attribute.include?(Object.new)).to be false
      end

      it 'should return false when method returns false' do
        attribute = described_class.new(:id, { if: :false })
        expect(attribute.include?(self.class::BooleanTestClass.new)).to be false
      end

      it 'should throw when method does not exist' do
        attribute = described_class.new(:id, { if: :false })
        expect { attribute.include?(Object.new) }.to raise_error(NoMethodError)
      end
    end

    context 'with unless option' do
      it 'should return false when Proc returns true' do
        attribute = described_class.new(:id, { unless: proc { true } })
        expect(attribute.include?(Object.new)).to be false
      end

      it 'should return false when method returns true' do
        attribute = described_class.new(:id, { unless: :true })
        expect(attribute.include?(self.class::BooleanTestClass.new)).to be false
      end

      it 'should return true when Proc returns false' do
        attribute = described_class.new(:id, { unless: proc { false } })
        expect(attribute.include?(Object.new)).to be true
      end

      it 'should return true when method returns false' do
        attribute = described_class.new(:id, { unless: :false })
        expect(attribute.include?(self.class::BooleanTestClass.new)).to be true
      end

      it 'should throw when method does not exist' do
        attribute = described_class.new(:id, { unless: :false })
        expect { attribute.include?(Object.new) }.to raise_error(NoMethodError)
      end
    end
  end

  describe '.exclude?' do
    context 'with :if option' do
      it 'should return false when Proc returns true' do
        attribute = described_class.new(:id, { if: proc { true } })
        expect(attribute.exclude?(Object.new)).to be false
      end

      it 'should return false when method returns true' do
        attribute = described_class.new(:id, { if: :true })
        expect(attribute.exclude?(self.class::BooleanTestClass.new)).to be false
      end

      it 'should return true when Proc returns false' do
        attribute = described_class.new(:id, { if: proc { false } })
        expect(attribute.exclude?(Object.new)).to be true
      end

      it 'should return true when method returns false' do
        attribute = described_class.new(:id, { if: :false })
        expect(attribute.exclude?(self.class::BooleanTestClass.new)).to be true
      end

      it 'should throw when method does not exist' do
        attribute = described_class.new(:id, { if: :false })
        expect { attribute.exclude?(Object.new) }.to raise_error(NoMethodError)
      end
    end

    context 'with unless option' do
      it 'should return true when Proc returns true' do
        attribute = described_class.new(:id, { unless: proc { true } })
        expect(attribute.exclude?(Object.new)).to be true
      end

      it 'should return true when method returns true' do
        attribute = described_class.new(:id, { unless: :true })
        expect(attribute.exclude?(self.class::BooleanTestClass.new)).to be true
      end

      it 'should return false when Proc returns false' do
        attribute = described_class.new(:id, { unless: proc { false } })
        expect(attribute.exclude?(Object.new)).to be false
      end

      it 'should return false when method returns false' do
        attribute = described_class.new(:id, { unless: :false })
        expect(attribute.exclude?(self.class::BooleanTestClass.new)).to be false
      end

      it 'should throw when method does not exist' do
        attribute = described_class.new(:id, { unless: :false })
        expect { attribute.exclude?(Object.new) }.to raise_error(NoMethodError)
      end
    end
  end

  describe '.evaluate' do
    it 'should call the block with a block' do
      expect do |b|
        attribute = described_class.new(:id, {}, &b)
        attribute.evaluate(Object.new)
      end.to yield_control
    end

    it 'should call value on the object with no block' do
      attribute = described_class.new(:id)
      obj = Object.new
      expect(obj).to receive(:evaluate_attribute).with(:id)

      attribute.evaluate(obj)
    end
  end
end
