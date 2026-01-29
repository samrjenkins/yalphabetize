# frozen_string_literal: true

require 'psych'

module Psych
  module Comments
    class Parser < Psych::Parser
      def parse(yaml)
        ast = super.handler.root

        Analyzer.new(yaml).visit(ast)
      end
    end
  end
end
