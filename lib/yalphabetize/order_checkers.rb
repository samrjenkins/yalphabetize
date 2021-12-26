# frozen_string_literal: true

module Yalphabetize
  module OrderCheckers
    DEFAULT = CapitalizedFirstThenAlphabetical

    TOKEN_MAPPING = {
      'abAB' => CapitalizedLastThenAlphabetical,
      'aAbB' => AlphabeticalThenCapitalizedLast,
      'AaBb' => AlphabeticalThenCapitalizedFirst,
      'ABab' => CapitalizedFirstThenAlphabetical
    }.freeze
  end
end
