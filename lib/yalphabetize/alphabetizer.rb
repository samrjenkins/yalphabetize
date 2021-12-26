# frozen_string_literal: true

module Yalphabetize
  class Alphabetizer
    def initialize(stream_node, order_checker_class:)
      @stream_node = stream_node
      @order_checker_class = order_checker_class
    end

    def call
      transform(stream_node)
      alphabetize(stream_node)
      stream_node
    end

    private

    attr_reader :stream_node, :order_checker_class

    def alphabetize(node)
      if node.mapping?
        alphabetize_children(node)
        unpair_children(node)
      end

      node.children&.each { |child_node| alphabetize(child_node) }
    end

    def alphabetize_children(node)
      node.children.sort! do |a, b|
        order_checker_class.compare(a.first.value, b.first.value)
      end
    end

    def unpair_children(node)
      children_clone = node.children.dup

      children_clone.each do |slice|
        node.children.push(*slice)
        node.children.shift
      end
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
