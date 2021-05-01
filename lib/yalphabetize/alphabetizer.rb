module Yalphabetize
  class Alphabetizer
    def initialize(document_node)
      @document_node = document_node
    end

    def call
      alphabetize(document_node)
      document_node
    end

    private

    attr_reader :document_node

    def alphabetize(node)
      if node.mapping?
        alphabetize_children(node)
        unpair_children(node)
      end

      node.children&.each { |child_node| alphabetize(child_node) }
    end

    def alphabetize_children(node)
      node.children.sort_by! { |key, _value| key.value }
    end

    def unpair_children(node)
      children_clone = node.children.dup

      children_clone.each do |slice|
        node.children.push(*slice)
        node.children.shift
      end
    end
  end
end
