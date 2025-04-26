# frozen_string_literal: true

require_relative('./builders/conditions')
require_relative('./handlers/block')
require_relative('./handlers/symbol')

module BBAttributeFilters
  # The attribute class. Wraps up a single instances of an attribute with the
  # handler and condition
  class Attribute
    def initialize(name, options = {}, &block)
      raise ArgumentError, 'BBAttributeFilters::Attribute - Name should be a symbol' unless name.is_a?(::Symbol)

      @name = name
      @handler = build_handler(name, &block)
      @condition = build_condition(options)
    end

    def include?(serializer)
      @condition.include?(serializer)
    end

    def exclude?(serializer)
      @condition.exclude?(serializer)
    end

    def evaluate(serializer)
      @handler.evaluate(serializer)
    end

    def condition_type
      @condition.type
    end

    private

    def build_condition(options)
      Builders::Conditions.build_from_options(options)
    end

    def build_handler(name, &block)
      if block_given?
        BBAttributeFilters::Handlers::Block.new(&block)
      else
        BBAttributeFilters::Handlers::Evaluation.new(name)
      end
    end
  end
end
