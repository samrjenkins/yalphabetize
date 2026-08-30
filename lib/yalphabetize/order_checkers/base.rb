# frozen_string_literal: true

module Yalphabetize
  module OrderCheckers
    class Base
      class << self
        def new_for(node)
          node_keys = keys_for(node)

          if matched_allowed_order(node_keys)
            Custom.new matched_allowed_order(node_keys)
          elsif matched_allowed_patterns_order(node_keys)
            CustomPattern.new matched_allowed_patterns_order(node_keys)
          else
            new
          end
        end

        private

        def matched_allowed_order(node_keys)
          Yalphabetize.config['allowed_orders']&.find do |allowed_order|
            (node_keys - allowed_order).empty?
          end
        end

        def matched_allowed_patterns_order(node_keys)
          Yalphabetize.config['allowed_patterns_orders']&.find do |allowed_patterns_order|
            node_keys.grep_v(/#{allowed_patterns_order.join('|')}/).empty?
          end
        end

        def keys_for(node)
          node.children.select.each_with_index do |_, i|
            i.even?
          end.map(&:value)
        end
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
