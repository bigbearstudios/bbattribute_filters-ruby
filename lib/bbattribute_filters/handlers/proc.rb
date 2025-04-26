# frozen_string_literal: true

module BBAttributeFilters
  module Handlers
    # Handler which calls the proc within the scope
    # of the evaluator
    class Proc
      def initialize(proc)
        unless proc.is_a?(::Proc)
          raise ArgumentError, 'BBAttributeFilters::Handlers::EvaluationHandler - Expected a Proc'
        end

        @proc = proc
      end

      def evaluate(evaluator)
        evaluator.instance_exec(&@proc)
      end
    end
  end
end
