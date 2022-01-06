# frozen_string_literal: true

module Yalphabetize
  module OrderCheckers
    class CapitalizedFirstThenAlphabetical < Base
      def self.compare(string, other_string)
        string <=> other_string
      end
    end
  end
end
