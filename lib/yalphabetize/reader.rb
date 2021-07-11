# frozen_string_literal: true

require 'psych'
require 'securerandom'
require 'yalphabetize/erb_compiler'
require 'yalphabetize/parsing_error'

module Yalphabetize
  class Reader
    def initialize(path)
      @path = path
      @interpolations_mapping = {}
    end

    def to_ast
      substitute_interpolations
      transform(stream_node)
      stream_node
    end

    attr_reader :interpolations_mapping

    private

    attr_reader :path

    def substitute_interpolations
      erb_compiler = Yalphabetize::ErbCompiler.new
      erb_compiler.compile(file)

      erb_compiler.content.each do |interpolation|
        uuid = SecureRandom.uuid
        file.sub!(interpolation, uuid)
        interpolations_mapping[uuid] = interpolation
      end
    end

    def file
      @_file ||= File.read(path)
    end

    def stream_node
      @_stream_node ||= Psych.parse_stream file
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
