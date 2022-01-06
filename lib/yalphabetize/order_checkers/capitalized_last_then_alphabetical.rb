# frozen_string_literal: true

# abAB
module Yalphabetize
  module OrderCheckers
    class CapitalizedLastThenAlphabetical < Base
      def self.compare(string, other_string)
        string.swapcase <=> other_string.swapcase
      end
    end
  end
end
