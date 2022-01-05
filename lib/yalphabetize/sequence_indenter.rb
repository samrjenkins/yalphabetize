# frozen_string_literal: true

require 'psych'

module Yalphabetize
  class SequenceIndenter
    def self.call(content)
      new(content).call
    end

    def initialize(content)
      @content = content
    end

    def call
      return unless Yalphabetize.config['indent_sequences']

      find_lines_to_indent
      indent!
      file_lines.join
    end

    private

    attr_reader :content

    def find_lines_to_indent
      @nodes_to_indent = []

      stream_node.select(&:mapping?).each do |mapping_node|
        block_sequence_nodes(mapping_node)&.each do |sequence_node|
          @nodes_to_indent.push(*sequence_node.children)
        end
      end
    end

    def block_sequence_nodes(node)
      node.children&.select { |child_node| child_node.sequence? && child_node.style == 1 }
    end

    def stream_node
      Psych.parse_stream content
    end

    def indent!
      @nodes_to_indent.each do |node|
        node_end_line = node.start_line == node.end_line ? node.end_line : node.end_line - 1

        file_lines[node.start_line..node_end_line].each do |line|
          line.gsub!(line, "  #{line}")
        end
      end
    end

    def file_lines
      @_file_lines ||= content.each_line.to_a
    end
  end
end
