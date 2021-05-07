# frozen_string_literal: true

module Yalphabetize
  class Writer
    def initialize(document_node, path)
      @document_node = document_node
      @path = path
    end

    def call
      File.open(path, 'w') do |file|
        file.write(document_node.to_yaml)
      end
    end

    private

    attr_reader :document_node, :path
  end
end
