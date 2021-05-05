module Yalphabetize
  class OffenceDetector
    def initialize(document_node)
      @document_node = document_node
    end

    def offences?
      !alphabetized?(document_node)
    end

    private

    attr_reader :document_node

    def alphabetized?(node)
      return false if node.mapping? && !alphabetized_children?(node)

      if node.children
        node.children&.flatten&.inject(true) { |bool, child_node| bool && alphabetized?(child_node) }
      else
        true
      end
    end

    def alphabetized_children?(node)
      node.children.each_cons(2).all? { |a, b| (a.first.value <=> b.first.value) <= 0 }
    end
  end
end
