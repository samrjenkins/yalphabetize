# frozen_string_literal: true

require_relative 'lib/yalphabetize/version'

Gem::Specification.new do |s|
  s.name        = 'yalphabetize'
  s.version     = Yalphabetize::Version::STRING
  s.summary     = 'Alphabetize your YAML files'
  s.authors     = ['Sam Jenkins']
  s.files       = Dir['{bin,lib}/**/*']
  s.executables << 'yalphabetize'
  s.metadata = {
    'rubygems_mfa_required' => 'true'
  }
  s.add_dependency 'psych-comments'
  s.post_install_message = <<~MESSAGE
    yalphabetize 0.10.0 now supports YAML comments!
    For more info: https://github.com/samrjenkins/yalphabetize?tab=readme-ov-file#preserve_comments
  MESSAGE
end
