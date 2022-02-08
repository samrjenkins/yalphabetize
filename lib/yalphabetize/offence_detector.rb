# frozen_string_literal: true

module Yalphabetize
  class OffenceDetector
    def initialize(stream_node, order_checker_class:)
      @stream_node = stream_node
      @order_checker_class = order_checker_class
    end

    def offences?
      !alphabetized?(stream_node)
    end

    private

    attr_reader :stream_node, :order_checker_class

    def alphabetized?(node)
      return false if node.mapping? && !alphabetized_children?(node)

      if node.children
        each_child_also_alphabetized?(node.children)
      else
        true
      end
    end

    def alphabetized_children?(node)
      node.children.each_slice(2).each_cons(2).all? do |a, b|
        order_checker_class.new_for(node).ordered?(a.first.value, b.first.value)
      end
    end

    def each_child_also_alphabetized?(children)
      children.flatten&.inject(true) { |bool, child_node| bool && alphabetized?(child_node) }
    end
  end
end
