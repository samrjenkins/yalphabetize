# frozen_string_literal: true

module Yalphabetize
  class Logger
    DEFAULT_OUTPUT = $stdout

    def initialize(output = DEFAULT_OUTPUT)
      @output = output
      @inspected_count = 0
      @offences = {}
    end

    def initial_summary(file_paths)
      output.puts "Inspecting #{file_paths.size} YAML files"
    end

    def log_offence(file_path)
      @inspected_count += 1
      offences[file_path] = :detected
      output.print red 'O'
    end

    def log_no_offence
      @inspected_count += 1
      output.print green '.'
    end

    def final_summary
      output.puts "\nInspected: #{inspected_count}"
      output.puts send(list_offences_color, "Offences: #{offences.size}")

      offences.each { |file_path, status| puts_offence(file_path, status) }
    end

    def offences?
      @offences.any?
    end

    def log_correction(file_path)
      offences[file_path] = :corrected
    end

    private

    attr_reader :offences, :inspected_count, :output

    def puts_offence(file_path, status)
      case status
      when :detected
        output.puts yellow file_path
      when :corrected
        output.puts("#{yellow(file_path)} #{green('CORRECTED')}")
      end
    end

    def list_offences_color
      if offences?
        :red
      else
        :green
      end
    end

    def red(string)
      with_color(31, string)
    end

    def yellow(string)
      with_color(33, string)
    end

    def green(string)
      with_color(32, string)
    end

    def with_color(color, string)
      "\e[#{color}m#{string}\e[0m"
    end
  end
end
