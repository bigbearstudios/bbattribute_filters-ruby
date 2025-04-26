# frozen_string_literal: true

require_relative('../handlers/proc')
require_relative('../handlers/symbol')

module BBAttributeFilters
  module Conditions
    # The base class for all AttributeConditions. E.g. allows the :if :unless conditions to be
    # used when creating attributes
    class Condition

      ALLOWED_CONDITIONS = %i[if unless none].freeze

      attr_reader :type

      def initialize(type, on)
        unless invalid_type?(type)
          raise ArgumentError, 'BBAttributeFilters::Conditions::Condition - Type should be :if, :unless or :none'
        end

        @type = type
        @on = on
        @handler = build_condition_handler(on)
      end

      def evaluate(evaluator)
        @handler.evaluate(evaluator)
      end

      def include?(_serializer)
        true
      end

      def exclude?(_serializer)
        false
      end

      private

      def invalid_type?(type)
        Condition::ALLOWED_CONDITIONS.include?(type)
      end

      # Builds the handler which will process the given condition.
      # Current options are Symbol, Proc
      def build_condition_handler(on)
        if on.is_a?(::Symbol)
          Handlers::Symbol.new(on)
        elsif on.is_a?(::Proc)
          Handlers::Proc.new(on)
        else
          raise ArgumentError, 'BBAttributeFilters::Conditions::Condition - Condition should be a symbol or Proc'
        end
      end
    end
  end
end
