# frozen_string_literal: true

module Yalphabetize
  class Alphabetizer
    def initialize(stream_node, order_checker_class:)
      @stream_node = stream_node
      @order_checker_class = order_checker_class
    end

    def call
      stream_node.select(&:mapping?).each do |node|
        order_checker = order_checker_class.new_for(node)
        pair_up_children(node)
        alphabetize_children(node, order_checker)
        unpair_children(node)
      end
    end

    private

    attr_reader :stream_node, :order_checker_class

    def alphabetize_children(node, order_checker)
      node.children.sort! do |a, b|
        order_checker.compare(a.first.value, b.first.value)
      end
    end

    def unpair_children(node)
      node.children.flatten!
    end

    def pair_up_children(node)
      children_clone = node.children.dup

      children_clone.each_slice(2) do |slice|
        node.children.push(slice)
        2.times { node.children.shift }
      end
    end
  end
end
