# frozen_string_literal: true

# aAbB
module Yalphabetize
  module OrderCheckers
    class AlphabeticalThenCapitalizedLast < Base
      def compare(string, other_string)
        alphabetical_comparison(string, other_string).nonzero? || string.swapcase <=> other_string.swapcase
      end
    end
  end
end
