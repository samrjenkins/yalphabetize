# frozen_string_literal: true

require './lib/yalphabetize/writer'

RSpec.describe Yalphabetize::Writer do
  describe '#call' do
    subject { Yalphabetize::Writer.new(stream_node, file_path).call }

    let(:file_path) { 'spec/tmp/mock.yml' }
    let(:file) { double('File', write: nil) }
    let(:stream_node) do
      build(
        :stream_node,
        children: [
          build(
            :document_node,
            children: [
              build(:scalar_node, value: 'value')
            ]
          )
        ]
      )
    end

    it 'writes yaml to file' do
      expect(File).to receive(:open).with(file_path, 'w') do |_, &block|
        block.call(file)
      end
      expect(file).to receive(:write).with("--- value\n")

      subject
    end
  end
end
