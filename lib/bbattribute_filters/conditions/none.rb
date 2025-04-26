# frozen_string_literal: true

require_relative('condition')

module BBAttributeFilters
  # The collections module
  module Conditions
    # Allows the handling of no condition
    class None < Condition
      def initialize
        @type = :none
        @on = nil
      end
    end

    def evaluate(evaluator); end
  end
end
