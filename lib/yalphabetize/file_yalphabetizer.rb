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
    end

    def call
      if offences?
        logger.log_offence(file_path)
        autocorrect_file if autocorrect
      else
        logger.log_no_offence
      end

      replace_interpolations
    end

    private

    attr_reader :file_path, :reader_class, :offence_detector_class,
                :logger, :autocorrect, :alphabetizer_class, :writer_class

    def autocorrect_file
      sorted_stream_node = alphabetizer_class.new(unsorted_stream_node).call
      writer_class.new(sorted_stream_node, file_path).call
      logger.log_correction(file_path)
    end

    def offences?
      offence_detector_class.new(unsorted_stream_node).offences?
    end

    def replace_interpolations
      interpolations_mapping.each do |uuid, interpolation|
        file_content = File.read(file_path)
        file_content.sub!(uuid, interpolation)
        File.open(file_path, 'w') do |file|
          file.write file_content
        end
      end
    end

    def reader
      @_reader ||= reader_class.new(file_path)
    end

    def unsorted_stream_node
      @_unsorted_stream_node ||= reader.to_ast
    end

    def interpolations_mapping
      reader.interpolations_mapping
    end
  end
end
