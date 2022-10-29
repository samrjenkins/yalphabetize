# frozen_string_literal: true

module Yalphabetize
  class FileYalphabetizer
    def initialize(file_path, **options)
      @file_path = file_path
      @reader_class = options[:reader_class]
      @offence_detector_class = options[:offence_detector_class]
      @logger = options[:logger]
      @autocorrect = options[:autocorrect]
      @alphabetizer_class = options[:alphabetizer_class]
      @writer_class = options[:writer_class]
      @order_checker_class = options[:order_checker_class]
    end

    def call
      return logger.log_no_offence unless offences?

      logger.log_offence(file_path)
      autocorrect_file if autocorrect
    end

    private

    attr_reader :file_path, :reader_class, :offence_detector_class, :logger, :autocorrect,
                :alphabetizer_class, :writer_class, :order_checker_class

    def autocorrect_file
      alphabetize
      handle_aliases
      rewrite_yml_file
      print_to_log
    end

    def offences?
      offence_detector_class.new(stream_node, order_checker_class: order_checker_class).offences?
    end

    def alphabetize
      alphabetizer_class.new(stream_node, order_checker_class: order_checker_class).call
    end

    def handle_aliases
      Aliaser.new(stream_node).call
    end

    def rewrite_yml_file
      writer_class.new(stream_node, file_path).call
    end

    def print_to_log
      logger.log_correction(file_path)
    end

    def reader
      @_reader ||= reader_class.new(file_path)
    end

    def stream_node
      @_stream_node ||= reader.to_ast
    end
  end
end
