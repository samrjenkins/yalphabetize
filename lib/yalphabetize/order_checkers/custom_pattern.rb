# frozen_string_literal: true

module Yalphabetize
  module OrderCheckers
    class CustomPattern < Base
      def initialize(allowed_order)
        super()
        @allowed_order = allowed_order
      end

      def compare(string, other_string)
        "#{index_of string}#{string}" <=> "#{index_of other_string}#{other_string}"
      end

      private

      attr_reader :allowed_order

      def index_of(str)
        allowed_order.index do |elem|
          Regexp.new(elem).match? str
        end
      end
    end
  end
end
