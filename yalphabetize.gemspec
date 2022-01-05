# frozen_string_literal: true

require_relative 'lib/yalphabetize/version'

Gem::Specification.new do |s|
  s.name        = 'yalphabetize'
  s.version     = Yalphabetize::Version::STRING
  s.summary     = 'Alphabetize your YAML files'
  s.authors     = ['Sam Jenkins']
  s.files       = Dir['{bin,lib}/**/*']
  s.executables << 'yalphabetize'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov'
  s.metadata = {
    'rubygems_mfa_required' => 'true'
  }
end
