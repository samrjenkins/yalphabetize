# frozen_string_literal: true

require 'open3'

class Yalphabetizer
  def self.call(args = [], **options)
    new(args, options).call
  end

  def initialize(args, options)
    @args = args

    @reader = options[:reader]
    @finder = options[:finder]
    @alphabetizer = options[:alphabetizer]
    @writer = options[:writer]
    @offence_detector = options[:offence_detector]
    @logger = options[:logger]
  end

  def call
    logger.initial_summary(file_paths)
    file_paths.each(&method(:process_file))
    logger.final_summary
    logger.offences? ? 1 : 0
  end

  private

  attr_reader :args, :reader, :finder, :alphabetizer, :writer, :offence_detector, :logger

  def process_file(file_path)
    unsorted_stream_node = reader.new(file_path).to_ast

    if offences?(unsorted_stream_node)
      logger.log_offence(file_path)
      autocorrect(unsorted_stream_node, file_path) if autocorrect?
    else
      logger.log_no_offence
    end
  end

  def file_paths
    finder.paths
  end

  def autocorrect?
    return true if args.include? '-a'
    return true if args.include? '-autocorrect'

    false
  end

  def autocorrect(unsorted_stream_node, file_path)
    sorted_stream_node = alphabetizer.new(unsorted_stream_node).call
    writer.new(sorted_stream_node, file_path).call
    logger.log_correction(file_path)
  end

  def offences?(stream_node)
    offence_detector.new(stream_node).offences?
  end
end
