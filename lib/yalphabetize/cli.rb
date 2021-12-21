# frozen_string_literal: true

module Yalphabetize
  class CLI
    def self.call(argv)
      new(argv).call
    end

    def initialize(argv)
      @argv = argv
    end

    def call
      Yalphabetizer.call argv, options
    end

    private

    attr_reader :argv

    def options
      OptionParser.parse!(argv)
    end
  end
end
