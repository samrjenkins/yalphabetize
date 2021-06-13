# frozen_string_literal: true

module Yalphabetize
  class Writer
    MAX_LINE_WIDTH = -1

    def initialize(stream_node, path)
      @stream_node = stream_node
      @path = path
    end

    def call
      File.open(path, 'w') do |file|
        file.write(stream_node.to_yaml(nil, line_width: MAX_LINE_WIDTH))
      end
    end

    private

    attr_reader :stream_node, :path
  end
end
