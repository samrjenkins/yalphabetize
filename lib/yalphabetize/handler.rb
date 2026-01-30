# frozen_string_literal: true

require 'psych'

module Yalphabetize
  class Handler < Psych::TreeBuilder
    def initialize(order_checker_class)
      super()
      @order_checker_class = order_checker_class
      @offences = false
    end

    attr_writer :comment_extractor

    def offences?
      offences
    end

    def start_document(*)
      super.tap do |node|
        comment_extractor&.start_document(node)
      end
    end

    def end_document(*)
      super.tap do |node|
        comment_extractor&.end_document(node)
      end
    end

    def start_stream(*)
      super
    end

    def end_stream(*)
      super.tap do |node|
        comment_extractor&.end_stream(node)
      end
    end

    def start_mapping(*)
      super
    end

    def end_mapping
      super.tap do |node|
        #
        check_offences(node)
      end
    end

    def scalar(...)
      super.tap do |node|
        comment_extractor&.scalar(node)
      end
    end

    def alias(...)
      super.tap do |node|
        comment_extractor&.alias(node)
      end
    end

    def start_sequence(*)
      super
    end

    def end_sequence(*)
      super
    end

    private

    attr_reader :order_checker_class, :last, :comment_extractor
    attr_accessor :offences

    def check_offences(node)
      return if offences?

      self.offences = true unless alphabetized_children?(node)
    end

    def alphabetized_children?(node)
      order_checker = order_checker_class.new_for(node)

      node.children.each_slice(2).each_cons(2).all? do |a, b|
        order_checker.ordered?(a.first.value, b.first.value)
      end
    end
  end
end
