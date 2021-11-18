# frozen_string_literal: true

require 'psych'
require 'securerandom'
require_relative 'erb_compiler'
require_relative 'parsing_error'

module Yalphabetize
  class Reader
    def initialize(path)
      @path = path
      @interpolations_mapping = {}
    end

    def to_ast
      substitute_interpolations
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
  end
end
