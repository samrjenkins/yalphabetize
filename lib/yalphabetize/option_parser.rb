# frozen_string_literal: true

require 'optparse'

module Yalphabetize
  class OptionParser
    PARSER = ::OptionParser.new do |o|
      o.banner = 'Usage: yalphabetize [options] [file1, file2, ...]'

      o.on('-a', '--autocorrect', 'Automatically alphabetize inspected yaml files')
      o.on('-h', '--help', 'Prints this help') do
        puts o
        Kernel.exit
      end
    end

    def self.parse!(argv)
      {}.tap { |options| PARSER.parse!(argv, into: options) }
    end
  end
end
