# frozen_string_literal: true

require 'psych'

module Yalphabetize
  class ParsingError < Psych::SyntaxError; end
end
