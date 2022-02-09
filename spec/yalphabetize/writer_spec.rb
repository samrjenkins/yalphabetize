# frozen_string_literal: true

RSpec.describe Yalphabetize::Writer do
  describe '#call' do
    subject { described_class.new(stream_node, file_path).call }

    let(:file_path) { 'spec/tmp/mock.yml' }
    let(:file) { double('File', write: nil) }
    let(:stream_node) do
      build(
        :stream_node,
        children: [
          build(
            :document_node,
            children: document_children
          )
        ]
      )
    end
    let(:document_children) { [build(:scalar_node, value: 'value')] }

    it 'writes yaml to file' do
      expect(File).to receive(:write).with(file_path, "--- value\n")
      subject
    end

    context 'when writing yaml that exceeds default psych line length' do
      let(:a_long_string) { ('x ' * 50).strip }
      let(:document_children) { [build(:scalar_node, value: a_long_string)] }

      it 'does not add extra line breaks' do
        expect(File).to receive(:write).with(file_path, "--- #{a_long_string}\n")
        subject
      end
    end
  end
end
