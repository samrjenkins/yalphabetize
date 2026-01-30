# frozen_string_literal: true

require 'psych/comments'

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
      @_new_file_content ||= if Yalphabetize.config['preserve_comments']
                               Psych::Comments.emit_yaml stream_node
                             else
                               stream_node.to_yaml(nil, line_width: MAX_LINE_WIDTH)
                             end
    end

    def indent_sequences
      @_new_file_content = SequenceIndenter.call(new_file_content)
    end
  end
end
