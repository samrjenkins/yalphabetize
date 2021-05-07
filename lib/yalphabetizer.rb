# frozen_string_literal: true

require 'open3'
require 'pry'

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

    @offences = []
  end

  def call
    file_paths.each do |file_path|
      unsorted_stream_node = reader.new(file_path).to_ast

      if offences?(unsorted_stream_node)
        autocorrect(unsorted_stream_node, file_path) if autocorrect?
        offences << file_path
      end
    end

    offences.none?
  end

  private

  attr_reader :args, :offences, :reader, :finder, :alphabetizer, :writer, :offence_detector

  def file_paths
    finder.new.paths
  end

  def autocorrect?
    return true if args.include? '-a'
    return true if args.include? '-autocorrect'

    false
  end

  def autocorrect(unsorted_stream_node, file_path)
    sorted_stream_node = alphabetizer.new(unsorted_stream_node).call
    writer.new(sorted_stream_node, file_path).call
  end

  def offences?(stream_node)
    offence_detector.new(stream_node).offences?
  end
end
