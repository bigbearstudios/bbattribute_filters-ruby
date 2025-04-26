# BBAttribute Filters

## Deprecation Warning

BBAttributeFilters has now been deprecated. The code is still avalible and version 1.0.0 is still fully functionality but there will be no futher updates to this repo.

## Introduction

BBAttribute Filters is a fairly specialised package which allows developers to define attributes on a given class along with the conditions under which those attributes should be accessable. The main purpose of this library is to be used as a base for BBSerializers Rails but it has been release seperately as it might come in handy for other purposes.

Below is a simple example of how to define attributes, the example imagines we are building some sort of serializer:

## Installation

Add it to your Gemfile:

``` ruby
gem 'bbattribute_filters'
```

## Usage

### Quick Start

```ruby

class Serializer 
  include BBAttributeFilters

  #A collection of symbols can be passed to attributes, each one will be sent to `value_for_attribute`
  attributes :id, :first_name, :last_name, :full_name
  attribute :admin_name, if: :is_admin? #Symbols will be handled via a method
  attribute :test_name, if: proc { serialized_object.is_test? } #A proc can be used to inline any checks

  #Attribute 
  attribute :full_name_via_block do 
    "#{serialized_object.first_name}  #{serialized_object.last_name}"
  end

  #By default the handler for all attributes will be self
  #and thus you would need to override the value_for_attribute(attribute)
  #method
  def evaluate_attribute(attribute)
    #Inside of here you can do as you please. We are building a serializer so we 
    #are going to check if the current object responsed to the attribute, or 
    #pass it through to the serialized object

    if respond_to?(attr_name)
      send(attr_name)
    else
      serialized_object.send(attr_name)
    end
  end

  #Here we define our `full_name` method so we can override the functionality which
  #doesn't exist on the underlying object
  def full_name 
    "#{serialized_object.first_name}  #{serialized_object.last_name}"
  end

  def is_admin?
    serialized_object.is_admin?
  end
end

```

## Contributing

- Clone the repository
- Install bundler `gem install bundler`
- Install gems `bundle`
- Write / push some code
- Create a PR via `https://gitlab.com/big-bear-studios-open-source/bbattributefilters/-/merge_requests`

### Running Tests

``` bash
bundle exec rspec
```

### Running Rubocop

``` bash
bundle exec rubocop
```

### Publishing (Required Ruby Gems Access)

``` bash
gem build bbattribute_filters.gemspec
gem push bbattribute_filters-*.*.*.gem
```

### Future Development

- Add complete error handling on overriden methods.
- Rspec Test Helpers

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
