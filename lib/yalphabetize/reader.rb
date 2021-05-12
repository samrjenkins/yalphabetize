# frozen_string_literal: true

require 'psych'
require 'yalphabetize/parsing_error'

module Yalphabetize
  class Reader
    def initialize(path)
      @path = path
    end

    def to_ast
      transform(stream_node)
      stream_node
    end

    private

    attr_reader :path

    def stream_node
      @_stream_node ||= Psych.parse_stream File.read(path)
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

    def transform(node)
      node.children&.each(&method(:transform))

      return unless node.mapping?

      pair_up_children(node)
    end

    def pair_up_children(node)
      children_clone = node.children.dup

      children_clone.each_slice(2) do |slice|
        node.children.push(slice)
        node.children.shift
        node.children.shift
      end
    end
  end
end
