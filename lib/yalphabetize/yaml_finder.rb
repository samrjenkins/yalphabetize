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

      files.flatten.select(&method(:valid?)).map { |f| File.expand_path(f) }.uniq
    end

    private

    attr_reader :files

    def process_paths(paths)
      paths.uniq.each do |path|
        files << if glob?(path)
                   files_in_glob(path)
                 elsif File.directory?(path)
                   files_in_dir(path)
                 else
                   path
                 end
      end
    end

    def files_in_glob(glob)
      files_in_dir([glob, glob.gsub('**', '')].uniq)
    end

    def files_in_dir(dir = Dir.pwd)
      return if `sh -c 'command -v git'`.empty?

      output, _error, status = Open3.capture3(
        'git', 'ls-files', '-z', *Array(dir),
        '--exclude-standard', '--others', '--cached', '--modified'
      )

      return unless status.success?

      output.split("\0").uniq
    end

    def valid?(path)
      exists?(path) && yml?(path)
    end

    def exists?(path)
      File.exist?(path)
    end

    def yml?(path)
      YAML_EXTENSIONS.include? File.extname(path)
    end

    def glob?(path)
      path.include?('*')
    end
  end
end
