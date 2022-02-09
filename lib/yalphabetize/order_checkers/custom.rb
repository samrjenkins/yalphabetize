# frozen_string_literal: true

module Yalphabetize
  module OrderCheckers
    class Custom < Base
      def initialize(allowed_order)
        super()
        @allowed_order = allowed_order
      end

      def compare(string, other_string)
        allowed_order.index(string) <=> allowed_order.index(other_string)
      end

      private

      attr_reader :allowed_order
    end
  end
end
