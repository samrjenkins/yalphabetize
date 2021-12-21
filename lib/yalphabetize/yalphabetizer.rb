# frozen_string_literal: true

module Yalphabetize
  class Yalphabetizer
    def self.call(args = [], options = {})
      new(args, options).call
    end

    def initialize(args, options)
      @args = args
      @options = options
    end

    def call
      initial_log
      process_files
      final_log
    end

    private

    attr_reader :args, :options

    def initial_log
      logger.initial_summary(file_paths)
    end

    def process_files
      file_paths.each(&method(:process_file))
    end

    def process_file(file_path)
      file_yalphabetizer_class.new(
        file_path,
        reader_class: reader_class,
        offence_detector_class: offence_detector_class,
        logger: logger,
        autocorrect: options[:autocorrect],
        alphabetizer_class: alphabetizer_class,
        writer_class: writer_class
      ).call
    end

    def file_paths
      finder.paths(args)
    end

    def final_log
      logger.final_summary
      logger.offences? ? 1 : 0
    end

    def reader_class
      Yalphabetize::Reader
    end

    def finder
      Yalphabetize::YamlFinder.new
    end

    def alphabetizer_class
      Yalphabetize::Alphabetizer
    end

    def writer_class
      Yalphabetize::Writer
    end

    def offence_detector_class
      Yalphabetize::OffenceDetector
    end

    def logger
      @_logger ||= Yalphabetize::Logger.new
    end

    def file_yalphabetizer_class
      Yalphabetize::FileYalphabetizer
    end
  end
end
