# frozen_string_literal: true

module Yalphabetize
  class YamlFinder
    def paths(paths)
      return files_in_dir if paths.empty?

      files = []

      paths.uniq.each do |path|
        files += if File.directory?(path)
                   files_in_dir(path)
                 else
                   process_explicit_path(path)
                 end
      end

      files.map { |f| File.expand_path(f) }.uniq
    end

    private

    def files_in_dir(dir = Dir.pwd)
      return if `sh -c 'command -v git'`.empty?

      output, _error, status = Open3.capture3(
        'git', 'ls-files', '-z', "#{dir}/*.yml",
        '--exclude-standard', '--others', '--cached', '--modified'
      )

      return unless status.success?

      output.split("\0").uniq
    end

    def process_explicit_path(path)
      path.include?('*') ? Dir[path] : [path]
    end
  end
end
