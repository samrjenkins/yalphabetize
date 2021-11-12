# frozen_string_literal: true

require 'yalphabetize/yalphabetizer'

module Yalphabetize
  class CLI
    def self.call(argv)
      new(argv).call
    end

    def initialize(argv)
      @argv = argv
    end

    def call
      Yalphabetizer.call argv
    end

    private

    attr_reader :argv
  end
end
