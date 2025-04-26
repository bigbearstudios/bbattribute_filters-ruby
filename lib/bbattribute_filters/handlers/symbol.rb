# frozen_string_literal: true

module BBAttributeFilters
  module Handlers
    # Handler which passes the symbol provided to the
    # evaluator
    class Symbol
      def initialize(symbol)
        unless symbol.is_a?(::Symbol)
          raise ArgumentError, 'BBAttributeFilters::Handlers::EvaluationHandler - Expected a Symbol'
        end

        @symbol = symbol
      end

      def evaluate(evaluator)
        evaluator.public_send(@symbol)
      end
    end
  end
end
