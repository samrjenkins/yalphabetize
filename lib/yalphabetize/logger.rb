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
      self.inspected_count += 1
      offences[file_path] = :detected
      output.print red 'O'
    end

    def log_no_offence
      self.inspected_count += 1
      output.print green '.'
    end

    def final_summary
      output.puts "\nInspected: #{inspected_count}"
      output.puts send(list_offences_color, "Offences: #{offences.size}")

      offences.each { |file_path, status| puts_offence(file_path, status) }
      return unless uncorrected_offences?

      output.puts 'Offences can be automatically fixed with `-a` or `--autocorrect`'
    end

    def uncorrected_offences?
      @offences.value?(:detected)
    end

    def log_correction(file_path)
      offences[file_path] = :corrected
    end

    private

    attr_reader :offences, :output
    attr_accessor :inspected_count

    def puts_offence(file_path, status)
      case status
      when :detected
        output.puts yellow file_path
      when :corrected
        output.puts("#{yellow(file_path)} #{green('CORRECTED')}")
      end
    end

    def list_offences_color
      uncorrected_offences? ? :red : :green
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
