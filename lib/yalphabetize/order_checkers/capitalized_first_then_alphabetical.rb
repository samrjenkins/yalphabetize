# frozen_string_literal: true

# ABab
module Yalphabetize
  module OrderCheckers
    class CapitalizedFirstThenAlphabetical < Base
      def compare(string, other_string)
        string <=> other_string
      end
    end
  end
end
