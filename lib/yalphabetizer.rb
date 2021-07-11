# frozen_string_literal: true

require 'open3'

class Yalphabetizer
  def self.call(args = [], **options)
    new(args, options).call
  end

  def initialize(args, options)
    @args = args

    @reader_class = options[:reader_class]
    @finder = options[:finder]
    @alphabetizer_class = options[:alphabetizer_class]
    @writer_class = options[:writer_class]
    @offence_detector_class = options[:offence_detector_class]
    @logger = options[:logger]
    @file_yalphabetizer_class = options[:file_yalphabetizer_class]
  end

  def call
    initial_log
    process_files
    final_log
  end

  private

  attr_reader :args, :reader_class, :finder, :alphabetizer_class, :writer_class,
              :offence_detector_class, :logger, :file_yalphabetizer_class

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
end
