# frozen_string_literal: true

require 'psych'
require 'psych/comments'

module Yalphabetize
  class Reader
    def initialize(path)
      @path = path
    end

    def to_ast
      stream_node
    end

    private

    attr_reader :path

    def file
      @_file ||= File.read(path)
    end

    def stream_node
      @_stream_node ||= Psych::Comments.parse_stream file
    rescue Psych::SyntaxError => e
      raise Yalphabetize::ParsingError.new(
        path,
        e.line,
        e.column,
        e.offset,
        e.problem,
        e.context
      )
    end
  end
end
