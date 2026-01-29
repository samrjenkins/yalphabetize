# frozen_string_literal: true

require 'psych'
require 'psych/comments'

module Yalphabetize
  class Reader
    def initialize(path)
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
      handler = Yalphabetize::Handler.new
      parser = parser_class.new(handler)
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

    def parser_class
      if Yalphabetize.config['preserve_comments']
        Psych::Comments::Parser
      else
        Psych::Parser
      end
    end
  end
end
