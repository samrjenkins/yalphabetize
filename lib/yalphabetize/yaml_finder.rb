# frozen_string_literal: true

require 'open3'
require 'pry'

module Yalphabetize
  class YamlFinder
    YAML_EXTENSIONS = %w[.yml .yaml].freeze

    def initialize
      @files = []
    end

    def paths(paths)
      if paths.empty?
        files << files_in_dir
      else
        process_paths(paths)
      end

      files.flatten.map { |f| File.expand_path(f) }.uniq
    end

    private

    attr_reader :files

    def process_paths(paths)
      paths.uniq.each do |path|
        files << if File.directory?(path)
                   files_in_dir(path)
                 else
                   next unless valid?(path)

                   process_explicit_path(path)
                 end
      end
    end

    def files_in_dir(dir = Dir.pwd)
      return if `sh -c 'command -v git'`.empty?

      output, _error, status = Open3.capture3(
        'git', 'ls-files', '-z', "#{dir}/*.yml", "#{dir}/*.yaml",
        '--exclude-standard', '--others', '--cached', '--modified'
      )

      return unless status.success?

      output.split("\0").uniq
    end

    def valid?(path)
      File.exist?(path) && YAML_EXTENSIONS.include?(File.extname(path))
    end

    def process_explicit_path(path)
      path.include?('*') ? Dir[path] : [path]
    end
  end
end
