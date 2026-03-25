# frozen_string_literal: true

require 'psych'

module Yalphabetize
  class Reader
    def initialize(path, handler)
      @path = path
      @handler = handler
    end

    def to_ast
      stream_node
    end

    private

    attr_reader :path, :handler

    def file
      @_file ||= File.read(path)
    end

    def stream_node
      handler.comment_extractor = CommentExtractor.new(file) if preserve_comments?
      parser = Psych::Parser.new(handler)
      parser.parse(file)

      @_stream_node ||= parser.handler.root
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

    def preserve_comments?
      Yalphabetize.config['preserve_comments']
    end
  end
end
