# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_group 'Libraries', '/lib/'
end

require 'bbattribute_filters'

require 'bbattribute_filters/conditions/condition'
require 'bbattribute_filters/conditions/if'
require 'bbattribute_filters/conditions/none'
require 'bbattribute_filters/conditions/unless'

require 'bbattribute_filters/handlers/evaluation'
require 'bbattribute_filters/handlers/proc'
require 'bbattribute_filters/handlers/symbol'

require 'bbattribute_filters/builders/conditions'
