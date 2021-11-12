# frozen_string_literal: true

require 'open3'
require 'yalphabetize/alphabetizer'
require 'yalphabetize/file_yalphabetizer'
require 'yalphabetize/logger'
require 'yalphabetize/offence_detector'
require 'yalphabetize/reader'
require 'yalphabetize/writer'
require 'yalphabetize/yaml_finder'

module Yalphabetize
  class Yalphabetizer
    def self.call(args = [])
      new(args).call
    end

    def initialize(args)
      @args = args
    end

    def call
      initial_log
      process_files
      final_log
    end

    private

    attr_reader :args

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
        autocorrect: autocorrect?,
        alphabetizer_class: alphabetizer_class,
        writer_class: writer_class
      ).call
    end

    def file_paths
      explicit_paths = args.reject { |arg| arg[0] == '-' }
      finder.paths(explicit_paths)
    end

    def autocorrect?
      return true if args.include? '-a'
      return true if args.include? '--autocorrect'

      false
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
