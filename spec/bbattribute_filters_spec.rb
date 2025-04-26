# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBAttributeFilters do
  context 'with an incomplete serializer' do
    class self::IncompleteSerializer
      include BBAttributeFilters

      attribute :value
    end

    subject { self.class::IncompleteSerializer.new }

    describe '.all_attributes' do
      it 'should throw a NoMethodError when evaluate_attribute has not been implemented' do
        expect { subject.all_attributes }.to raise_error(NoMethodError)
      end
    end

    describe '.attribute' do
      it 'should throw a NoMethodError when evaluate_attribute has not been implemented' do
        expect { subject.all_attributes }.to raise_error(NoMethodError)
      end
    end

    describe '.attribute_forced' do
      it 'should throw a NoMethodError when evaluate_attribute has not been implemented' do
        expect { subject.all_attributes }.to raise_error(NoMethodError)
      end
    end

    describe '.only_attributes' do
      it 'should throw a NoMethodError when evaluate_attribute has not been implemented' do
        expect { subject.all_attributes }.to raise_error(NoMethodError)
      end
    end
  end

  context 'with an inherited serializer' do
    class self::BaseSerializer
      include BBAttributeFilters

      attributes :value

      def initalize(object)
        @object = object
      end
    end

    class self::ParentSerializer < self::BaseSerializer

    end

    subject { self.class::ParentSerializer }

    describe '._get_fiterable_attributes' do
      it 'should be prepopulated with the base serializers attributes' do
        expect(subject._get_fiterable_attributes).to_not be nil
        expect(subject._get_fiterable_attributes.length).to be(1)
      end
    end
  end

  context 'with a attribute serializer' do
    class self::AttributeSerializer
      include BBAttributeFilters

      attribute :not_included_if, if: proc { false }
      attribute :included_if, if: proc { true }
      attribute :not_included_unless, unless: proc { true }
      attribute :included_unless, unless: proc { false }
      attribute :using_method
      attribute :using_block do
        true
      end
      attribute :using_method_with_a_key, key: :different_key

      def initialize(object)
        @object = object
      end

      def evaluate_attribute(attr_name)
        if respond_to?(attr_name)
          send(attr_name)
        else
          @object.public_send(attr_name)
        end
      end

      def using_method
        true
      end

      def using_method_with_a_key
        true
      end
    end

    subject { self.class::AttributeSerializer.new(serialized_object) }

    context 'with a serialized object which responds' do
      let(:serialized_object) do
        double.tap do |obj|
          allow(obj).to receive(:included_unless) { true }
          allow(obj).to receive(:included_if) { true }
          allow(obj).to receive(:not_included_if) { true }
          allow(obj).to receive(:not_included_unless) { true }
        end
      end

      describe '.all_attributes' do
        it 'should return the included variables' do
          expect(subject.all_attributes).to eq({
                                                 different_key: true,
                                                 included_if: true,
                                                 included_unless: true,
                                                 using_block: true,
                                                 using_method: true
                                               })
        end
      end

      describe '.attribute' do
        it 'should return the value for an included attribute' do
          expect(subject.attribute(:included_if)).to be true
        end

        it 'should not return the value for an excluded attribute' do
          expect(subject.attribute(:not_included_if)).to be nil
        end
      end

      describe '.attribute_forced' do
        it 'should return the value for an included attribute' do
          expect(subject.attribute_forced(:included_if)).to be true
        end

        it 'should return the value for an excluded attribute' do
          expect(subject.attribute_forced(:not_included_if)).to be true
        end
      end

      describe '.only_attributes' do
        it 'should only return the requested included attributes' do
          expect(subject.only_attributes(:included_if, :using_method)).to eq({
                                                                               included_if: true,
                                                                               using_method: true
                                                                             })
        end
      end
    end
  end

  context 'with a attributes serializer' do
    class self::AttributesSerializer
      include BBAttributeFilters

      attributes :included, :using_method

      def initialize(object)
        @object = object
      end

      def evaluate_attribute(attr_name)
        if respond_to?(attr_name)
          send(attr_name)
        else
          @object.public_send(attr_name)
        end
      end

      def using_method
        true
      end
    end

    subject { self.class::AttributesSerializer.new(serialized_object) }

    context 'with a serialized object which responds' do
      let(:serialized_object) do
        double.tap do |obj|
          allow(obj).to receive(:included) { true }
        end
      end

      describe '.all_attributes' do
        it 'should return the included variables' do
          expect(subject.all_attributes).to eq({
                                                 included: true,
                                                 using_method: true
                                               })
        end
      end

      describe '.attribute' do
        it 'should return the value for an included attribute' do
          expect(subject.attribute(:included)).to be true
        end
      end

      describe '.attribute_forced' do
        it 'should return the value for an included attribute' do
          expect(subject.attribute_forced(:included)).to be true
        end
      end

      describe '.only_attributes' do
        it 'should only return the requested included attributes' do
          expect(subject.only_attributes(:included)).to eq({
                                                             included: true
                                                           })
        end
      end
    end
  end
end
