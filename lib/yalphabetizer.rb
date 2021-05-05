require 'yalphabetize/reader'
require 'yalphabetize/alphabetizer'
require 'yalphabetize/writer'
require 'yalphabetize/offence_detector'
require 'yalphabetize/yaml_finder'
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

      if offences?(unsorted_document_node)
        autocorrect(unsorted_document_node, file_path) if autocorrect?
        offences << file_path
      end
    end

    offences.none?
  end

  private

  attr_reader :args, :offences

  def file_paths
    Yalphabetize::YamlFinder.new.paths
  end

  def autocorrect?
    return true if args.include? '-a'
    return true if args.include? '-autocorrect'

    false
  end

  def autocorrect(unsorted_document_node, file_path)
    sorted_document_node = Yalphabetize::Alphabetizer.new(unsorted_document_node).call
    Yalphabetize::Writer.new(sorted_document_node, file_path).call
  end

  def offences?(document_node)
    Yalphabetize::OffenceDetector.new(document_node).offences?
  end
end
