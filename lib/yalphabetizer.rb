require 'yalphabetize/reader'
require 'yalphabetize/alphabetizer'
require 'yalphabetize/writer'
require 'open3'
require 'pry'

class Yalphabetizer
  def self.call(args)
    new(args).call
  end

  def initialize(args)
    @args = args
  end

  def call
    file_paths.each do |file_path|
      unsorted_document_node = Yalphabetize::Reader.new(file_path).to_ast
      sorted_document_node = Yalphabetize::Alphabetizer.new(unsorted_document_node).call

      if autocorrect?
        Yalphabetize::Writer.new(sorted_document_node, file_path).call
      end
    end
  end

  private

  attr_reader :args

  def file_paths
    return if `sh -c 'command -v git'`.empty?

    output, _error, status = Open3.capture3(
      'git', 'ls-files', '-z', "./**/*.yml",
      '--exclude-standard', '--others', '--cached', '--modified'
    )

    return unless status.success?

    output.split("\0").map { |git_file| "#{Dir.pwd}/#{git_file}" }
  end

  def autocorrect?
    (args & ['-a', '--autocorrect']).any?
  end
end
