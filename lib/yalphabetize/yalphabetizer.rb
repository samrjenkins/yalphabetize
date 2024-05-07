# frozen_string_literal: true

require 'parallel'

module Yalphabetize
  class Yalphabetizer
    def self.call(args = [], options = {})
      new(args, options).call
    end

    def initialize(args, options)
      @args = args
      @options = options
      @offences = []
    end

    def call
      initial_log
      process_files
      final_log
      offences.any? ? 1 : 0
    end

    private

    attr_accessor :offences
    attr_reader :args, :options

    def initial_log
      logger.initial_summary(file_paths)
    end

    def process_files
      self.offences = Parallel.filter_map(
        file_paths,
        in_processes: 100,
        finish: -> (item, i, result) { result ? logger.log_offence : logger.log_no_offence }
      ) do |file_path|
        file_result = process_file(file_path)
        next if file_result.nil?

        [file_path, file_result]
      end
    end

    def process_file(file_path)
      file_yalphabetizer_class.new(
        file_path,
        reader_class:,
        offence_detector_class:,
        autocorrect: options[:autocorrect],
        alphabetizer_class:,
        writer_class:,
        order_checker_class:
      ).call
    end

    def file_paths
      @_file_paths ||= finder.paths(only: only_paths, exclude: Yalphabetize.config['exclude'])
    end

    def only_paths
      if args.any?
        args
      else
        Yalphabetize.config['only']
      end
    end

    def final_log
      logger.final_summary(file_paths.size, offences)
    end

    def reader_class
      Yalphabetize::Reader
    end

    def finder
      Yalphabetize::YamlFinder
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

    def order_checker_class
      OrderCheckers::TOKEN_MAPPING[Yalphabetize.config['sort_by']]
    end
  end
end
