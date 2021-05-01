require 'psych'

module Yalphabetize
  class Reader
    def initialize(path)
      @path = path
    end

    def to_ast
      transform(document_node)
      document_node
    end

    private

    attr_reader :path

    def document_node
      @document_node ||= Psych.parse_stream File.read(path)
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
