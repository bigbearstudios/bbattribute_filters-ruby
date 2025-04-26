# frozen_string_literal: true

module BBAttributeFilters
  module Handlers
    # Handler which passes the name of the attribute directly
    # to the BBAttributeFilter via the evaluate_attribute
    class Evaluation
      def initialize(symbol)
        unless symbol.is_a?(::Symbol)
          raise ArgumentError, 'BBAttributeFilters::Handlers::EvaluationHandler - Expected a Symbol'
        end

        @symbol = symbol
      end

      def evaluate(evaluator)
        evaluator.evaluate_attribute(@symbol)
      end
    end
  end
end
