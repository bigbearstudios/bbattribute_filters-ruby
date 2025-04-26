# frozen_string_literal: true

module BBAttributeFilters
  module Handlers
    # Handler which calls the block within the scope
    # of the evaluator
    class Block
      def initialize(&block)
        raise ArgumentError, 'BBAttributeFilters::Handlers::EvaluationHandler - Expected a Block' unless block_given?

        @block = block
      end

      def evaluate(evaluator)
        evaluator.instance_eval(&@block)
      end
    end
  end
end
