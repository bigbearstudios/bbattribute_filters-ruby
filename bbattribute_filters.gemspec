# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = 'bbattribute_filters'
  spec.version = '3.0.0'
  spec.authors = 'Stuart Farnaby, Big Bear Studios'
  spec.license = 'MIT'
  spec.homepage = 'https://github.com/bigbearstudios/bbattribute_filters-ruby'
  spec.summary = 'Deprecated'

  spec.required_ruby_version = '>= 2.5'

  spec.files = ['lib/bbattribute_filters.rb']
  spec.files += Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec', '3.9.0'
  spec.add_development_dependency 'simplecov', '0.18.5'
end
