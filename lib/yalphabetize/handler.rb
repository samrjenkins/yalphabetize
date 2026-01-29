# frozen_string_literal: true

module Yalphabetize
  class Handler < Psych::TreeBuilder
    def initialize
      super
      @duplicates = []
    end

    attr_reader :duplicates

    def end_mapping
      tally = {}

      @last.children.each_slice(2) do |key_node, _value_node|
        key = key_node.value
        duplicates << key if tally[key]

        tally[key] = true
      end

      super
    end
  end
end
