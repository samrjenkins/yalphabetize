# frozen_string_literal: true

module Yalphabetize
  class Aliaser
    def initialize(stream_node)
      @stream_node = stream_node
      @aliases = {}
    end

    def call
      nodes.each do |node|
        next unless node.respond_to?(:anchor) && node.anchor

        if node.alias?
          aliases[node.anchor] ||= node
        elsif aliases[node.anchor]
          swap(node, aliases[node.anchor])
        end
      end
      stream_node
    end

    private

    attr_reader :stream_node, :aliases

    def swap(anchor_node, alias_node)
      stream_node.each do |node|
        node.children&.map! do |child_node|
          if child_node == anchor_node
            alias_node
          elsif child_node == alias_node
            anchor_node
          else
            child_node
          end
        end
      end
    end

    def nodes
      stream_node.select do |node|
        node.respond_to?(:anchor) && node.anchor
      end
    end

    def anchor_nodes
      stream_node.select do |node|
        node.respond_to?(:anchor) && node.anchor && !node.alias?
      end
    end

    def alias_nodes
      stream_node.select(&:alias?)
    end
  end
end
