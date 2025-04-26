# frozen_string_literal: true

require_relative('../conditions/if')
require_relative('../conditions/unless')
require_relative('../conditions/none')

module BBAttributeFilters
  module Builders
    # Builder for conditions
    class Conditions
      class << self
        def build_from_options(options)
          if options.key?(:if)
            BBAttributeFilters::Conditions::If.new(options[:if])
          elsif options.key?(:unless)
            BBAttributeFilters::Conditions::Unless.new(options[:unless])
          else
            BBAttributeFilters::Conditions::None.new
          end
        end
      end
    end
  end
end
