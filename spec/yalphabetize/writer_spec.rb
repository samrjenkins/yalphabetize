# frozen_string_literal: true

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
            children: document_children
          )
        ]
      )
    end
    let(:document_children) { [build(:scalar_node, value: 'value')] }

    it 'writes yaml to file' do
      expect_to_write "--- value\n"
      subject
    end

    context 'when writing yaml that exceeds default psych line length' do
      let(:a_long_string) { ('x ' * 50).strip }
      let(:document_children) { [build(:scalar_node, value: a_long_string)] }

      it 'does not add extra line breaks' do
        expect_to_write "--- #{a_long_string}\n"
        subject
      end
    end

    def expect_to_write(content)
      expect(File).to receive(:open).with(file_path, 'w') do |_, &block|
        block.call(file)
      end
      expect(file).to receive(:write).with(content)
    end
  end
end
