# frozen_string_literal: true

module Yalphabetize
  class Writer
    MAX_LINE_WIDTH = -1

    def initialize(stream_node, path)
      @stream_node = stream_node
      @path = path
    end

    def call
      indent_sequences

      File.write(path, new_file_content)
    end

    private

    attr_reader :stream_node, :path

    def new_file_content
      @_new_file_content ||= Psych::Comments.emit_yaml stream_node
    end

    def indent_sequences
      @_new_file_content = SequenceIndenter.call(new_file_content)
    end
  end
end
