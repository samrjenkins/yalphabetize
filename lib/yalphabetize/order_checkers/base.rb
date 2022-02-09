# frozen_string_literal: true

module Yalphabetize
  module OrderCheckers
    class Base
      def self.new_for(node)
        node_keys = node.children.select.each_with_index do |_, i|
          i.even?
        end.map(&:value)

        matched_allowed_order = Yalphabetize.config['allowed_orders']&.find do |allowed_order|
          (node_keys - allowed_order).empty?
        end

        matched_allowed_order ? Custom.new(matched_allowed_order) : new
      end

      def ordered?(string, other_string)
        !compare(string, other_string).positive?
      end

      private

      def alphabetical_comparison(string, other_string)
        string.downcase <=> other_string.downcase
      end
    end
  end
end
