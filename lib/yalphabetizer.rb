require 'yalphabetize/reader'
require 'yalphabetize/alphabetizer'
require 'yalphabetize/writer'

class Yalphabetizer
  def self.call(path)
    unsorted_document_node = Yalphabetize::Reader.new(path).to_ast
    sorted_document_node = Yalphabetize::Alphabetizer.new(unsorted_document_node).call
    Yalphabetize::Writer.new(sorted_document_node, path).call
  end
end
