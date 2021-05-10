# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'yalphabetize'
  s.version     = '0.1.0'
  s.summary     = 'Alphabetize your YAML files'
  s.authors     = ['Sam Jenkins']
  s.files       = Dir['{bin,lib}/**/*']
  s.executables << 'yalphabetize'

  s.add_runtime_dependency('psych', '~> 3.3.1')

  s.add_development_dependency('bundler', '~> 2')
end
