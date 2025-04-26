# frozen_string_literal: true

require_relative 'bbattribute_filters/attribute'

# The main BBAttributeFilters module. Should be included to
module BBAttributeFilters
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      # Gets all of the class Attributes. Please note this is the internal attributes
      def filterable_attributes
        self.class._get_fiterable_attributes
      end

      # @abstract Subclass is expected to implement #evaluate_attribute
      # @!method evaluate_attribute(name)
      #   Evaluate the value of the attribute using the symbol provided

      # Gets all of the attributes as long as they pass the include? condition
      # check
      def all_attributes
        filterable_attributes.each_with_object({}) do |(key, attr), to_return|
          to_return[key] = attr.evaluate(self) if attr.include?(self)
        end
      end

      # Gets a single attribute via the name, this will run the include? check on
      # the attribute before evaulating it
      # @param name {Symbol} The name of the attribute to retrieve
      def attribute(name)
        attr = filterable_attributes[name]
        attr.evaluate(self) if attr&.include?(self)
      end

      # Gets a single attribute via the name but bypassed the included? check
      # @param name {Symbol} The name of the attribute to retrieve
      def attribute_forced(name)
        attr = filterable_attributes[name]
        attr ? attr.evaluate(self) : nil
      end

      # Gets a list of specific attributes based on the names give
      def only_attributes(*only)
        only.each_with_object({}) do |name, to_return|
          to_return[name] = attribute(name)
        end
      end
    end

    # Rather than wasting time with an if check each time we access the attributes hash we instead
    # set it up front upon include
    base._set_fiterable_attributes({})
  end

  # The class methods on BBAttributeFilters
  module ClassMethods
    def inherited(base)
      super
      base._set_fiterable_attributes(@_filterable_attributes ? @_filterable_attributes.dup : {})
    end

    # Assigns a large set of attributes without options
    def attributes(*attrs)
      attrs.each do |attr|
        attribute(attr)
      end
    end

    # Assigns a single attribute
    def attribute(name, options = {}, &block)
      _add_filterable_attribute(options.fetch(:key, name),
        BBAttributeFilters::Attribute.new(name, options, &block))
    end

    # Sets the serialized attributes variable
    def _set_fiterable_attributes(attrs)
      @_filterable_attributes = attrs
    end

    # Gets the serialized attributes variable
    def _get_fiterable_attributes
      @_filterable_attributes
    end

    # Adds a single serialized attribute. This is an internal method
    # used by the attribute method
    def _add_filterable_attribute(key, attr)
      @_filterable_attributes[key] = attr
    end
  end
end
