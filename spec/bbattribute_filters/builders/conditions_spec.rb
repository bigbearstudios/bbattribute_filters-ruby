# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBAttributeFilters::Builders::Conditions do
  context 'class methods' do
    describe 'build_from_options' do
      it 'should return a if condition with :if key' do
        expect(described_class.build_from_options(if: proc { true }))
          .to be_a BBAttributeFilters::Conditions::If
      end

      it 'should return a unless condition with :unless key' do
        expect(described_class.build_from_options(unless: proc { true }))
          .to be_a BBAttributeFilters::Conditions::Unless
      end

      it 'should return a none condition with :none key' do
        expect(described_class.build_from_options({}))
          .to be_a BBAttributeFilters::Conditions::None
      end
    end
  end
end
