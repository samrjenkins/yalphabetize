# frozen_string_literal: true

module Yalphabetize
  class YamlFinder
    def paths
      return if `sh -c 'command -v git'`.empty?

      output, _error, status = Open3.capture3(
        'git', 'ls-files', '-z', './**/*.yml',
        '--exclude-standard', '--others', '--cached', '--modified'
      )

      return unless status.success?

      output.split("\0").map { |git_file| "#{Dir.pwd}/#{git_file}" }
    end
  end
end
