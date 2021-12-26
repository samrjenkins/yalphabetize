# frozen_string_literal: true

# AaBb
module Yalphabetize
  module OrderCheckers
    class AlphabeticalThenCapitalizedFirst < Base
      def self.compare(string, other_string)
        alphabetical_comparison(string, other_string).nonzero? || string <=> other_string
      end
    end
  end
end
