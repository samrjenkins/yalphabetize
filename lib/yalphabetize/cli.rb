# frozen_string_literal: true

require 'yalphabetize/alphabetizer'
require 'yalphabetize/file_yalphabetizer'
require 'yalphabetize/logger'
require 'yalphabetize/offence_detector'
require 'yalphabetize/reader'
require 'yalphabetize/writer'
require 'yalphabetize/yaml_finder'
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
      Yalphabetizer.call(
        argv,
        reader_class: Yalphabetize::Reader,
        finder: Yalphabetize::YamlFinder.new,
        alphabetizer_class: Yalphabetize::Alphabetizer,
        writer_class: Yalphabetize::Writer,
        offence_detector_class: Yalphabetize::OffenceDetector,
        logger: Yalphabetize::Logger.new,
        file_yalphabetizer_class: Yalphabetize::FileYalphabetizer
      )
    end

    private

    attr_reader :argv
  end
end
