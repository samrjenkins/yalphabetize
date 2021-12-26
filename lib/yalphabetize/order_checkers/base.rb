# frozen_string_literal: true

module Yalphabetize
  module OrderCheckers
    class Base
      def self.ordered?(string, other_string)
        !compare(string, other_string).positive?
      end

      private_class_method def self.alphabetical_comparison(string, other_string)
        string.downcase <=> other_string.downcase
      end
    end
  end
end
