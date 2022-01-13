# frozen_string_literal: true

require_relative 'yalphabetize/aliaser'
require_relative 'yalphabetize/alphabetizer'
require_relative 'yalphabetize/cli'
require_relative 'yalphabetize/file_yalphabetizer'
require_relative 'yalphabetize/logger'
require_relative 'yalphabetize/offence_detector'
require_relative 'yalphabetize/option_parser'
require_relative 'yalphabetize/order_checkers/base'
require_relative 'yalphabetize/order_checkers/alphabetical_then_capitalized_first'
require_relative 'yalphabetize/order_checkers/alphabetical_then_capitalized_last'
require_relative 'yalphabetize/order_checkers/capitalized_last_then_alphabetical'
require_relative 'yalphabetize/order_checkers/capitalized_first_then_alphabetical'
require_relative 'yalphabetize/order_checkers'
require_relative 'yalphabetize/parsing_error'
require_relative 'yalphabetize/reader'
require_relative 'yalphabetize/sequence_indenter'
require_relative 'yalphabetize/version'
require_relative 'yalphabetize/writer'
require_relative 'yalphabetize/yalphabetizer'
require_relative 'yalphabetize/yaml_finder'

module Yalphabetize
  class << self
    DEFAULT_CONFIG = {
      'indent_sequences' => true,
      'exclude' => [],
      'only' => [],
      'sort_by' => 'ABab'
    }.freeze

    def config
      @_config ||= begin
        specified = if File.exist?('.yalphabetize.yml')
                      Psych.load_file('.yalphabetize.yml') || {}
                    else
                      {}
                    end

        DEFAULT_CONFIG.merge(specified)
      end
    end
  end
end
