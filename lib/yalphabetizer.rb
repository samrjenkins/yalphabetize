require 'yalphabetize/reader'
require 'yalphabetize/alphabetizer'
require 'yalphabetize/writer'
require 'yalphabetize/offence_detector'
require 'open3'
require 'pry'

class Yalphabetizer
  def self.call(args = [])
    new(args).call
  end

  def initialize(args)
    @args = args
    @offences = []
  end

  def call
    file_paths.each do |file_path|
      unsorted_document_node = Yalphabetize::Reader.new(file_path).to_ast

      has_offences = Yalphabetize::OffenceDetector.new(unsorted_document_node).offences?

      if autocorrect? && has_offences
        sorted_document_node = Yalphabetize::Alphabetizer.new(unsorted_document_node).call
        Yalphabetize::Writer.new(sorted_document_node, file_path).call
      end

      if has_offences
        offences << file_path
      end
    end

    offences.none?
  end

  private

  attr_reader :args, :offences

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
