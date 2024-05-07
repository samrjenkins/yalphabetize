# frozen_string_literal: true

module Yalphabetize
  class Logger
    DEFAULT_OUTPUT = $stdout

    def initialize(output = DEFAULT_OUTPUT)
      @output = output
    end

    def initial_summary(file_paths)
      output.puts "Inspecting #{file_paths.size} YAML files"
    end

    def log_offence
      output.print red 'O'
    end

    def log_no_offence
      output.print green '.'
    end

    def final_summary(inspected_count, results)
      output.puts "\nInspected: #{inspected_count}"
      output.puts send(list_offences_color(results.size), "Offences: #{results.size}")

      results.each { |file_path, status| puts_offence(file_path, status) }
      return if results.empty?

      output.puts 'Offences can be automatically fixed with `-a` or `--autocorrect`'
    end

    private

    attr_reader :output

    def puts_offence(file_path, status)
      case status
      when :detected
        output.puts yellow file_path
      when :corrected
        output.puts("#{yellow(file_path)} #{green('CORRECTED')}")
      end
    end

    def list_offences_color(number_of_offences)
      number_of_offences.zero? ? :green : :red
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
