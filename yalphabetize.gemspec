# frozen_string_literal: true

require_relative 'lib/yalphabetize/version'

Gem::Specification.new do |s|
  s.name        = 'yalphabetize'
  s.version     = Yalphabetize::Version::STRING
  s.summary     = 'Alphabetize your YAML files'
  s.authors     = ['Sam Jenkins']
  s.files       = Dir['{bin,lib}/**/*']
  s.executables << 'yalphabetize'
  s.homepage = 'https://github.com/samrjenkins/yalphabetize'
  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/samrjenkins/yalphabetize/issues',
    'changelog_uri' => "https://github.com/samrjenkins/yalphabetize/releases/tag/v#{Yalphabetize::Version::STRING}",
    'source_code_uri' => "https://github.com/samrjenkins/yalphabetize/tree/v#{Yalphabetize::Version::STRING}",
    'rubygems_mfa_required' => 'true'
  }
  s.add_dependency 'psych-comments'
end
