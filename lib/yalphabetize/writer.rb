# frozen_string_literal: true

module Yalphabetize
  class Writer
    MAX_LINE_WIDTH = -1

    def initialize(stream_node, path, interpolations_mapping)
      @stream_node = stream_node
      @path = path
      @interpolations_mapping = interpolations_mapping
    end

    def call
      indent_sequences
      replace_interpolations

      File.open(path, 'w') do |file|
        file.write new_file_content
      end
    end

    private

    attr_reader :stream_node, :path, :interpolations_mapping

    def new_file_content
      @_new_file_content ||= stream_node.to_yaml(nil, line_width: MAX_LINE_WIDTH)
    end

    def replace_interpolations
      interpolations_mapping.each do |uuid, interpolation|
        new_file_content.sub!(uuid, interpolation)
      end
    end

    def indent_sequences
      @_new_file_content = SequenceIndenter.call(new_file_content)
    end
  end
end
