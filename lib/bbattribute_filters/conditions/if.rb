# frozen_string_literal: true

require_relative('condition')

module BBAttributeFilters
  module Conditions
    ##
    # Allows the handling of the :if condition
    class If < Condition
      def initialize(on)
        super(:if, on)
      end

      def include?(serializer)
        evaluate(serializer)
      end

      def exclude?(serializer)
        !evaluate(serializer)
      end
    end
  end
end
