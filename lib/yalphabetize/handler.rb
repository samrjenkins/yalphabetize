# frozen_string_literal: true

module Yalphabetize
  class Handler < Psych::TreeBuilder
    def initialize(order_checker_class)
      super()
      @order_checker_class = order_checker_class
      @offences = false
    end

    def offences?
      offences
    end

    def end_mapping
      check_offences
      super
    end

    private

    attr_reader :order_checker_class, :last
    attr_accessor :offences

    def check_offences
      return if offences?

      self.offences = true unless alphabetized_children?(last)
    end

    def alphabetized_children?(node)
      order_checker = order_checker_class.new_for(node)

      node.children.each_slice(2).each_cons(2).all? do |a, b|
        order_checker.ordered?(a.first.value, b.first.value)
      end
    end
  end
end
