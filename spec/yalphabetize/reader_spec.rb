# frozen_string_literal: true

require './lib/yalphabetize/reader'

RSpec.describe Yalphabetize::Reader do
  let(:file_path) { 'spec/tmp/mock.yml' }
  let(:file_content) { '' }

  before do
    File.open(file_path, 'w') do |file|
      file.write(file_content)
    end
  end

  describe '#to_ast' do
    subject { Yalphabetize::Reader.new(file_path).to_ast }

    it { is_expected.to be_a Psych::Nodes::Stream }

    it 'opens and parses the file' do
      expect(File).to receive(:read).with(file_path).and_return('the_file')
      expect(Psych).to receive(:parse_stream).with('the_file').and_return('the_parsed_file')

      expect(subject).to eq 'the_parsed_file'
    end

    context 'when yaml contains invalid syntax' do
      let(:file_content) do
        <<~YAML
          `Apples: 1
        YAML
      end

      it do
        expect { subject }
          .to raise_error(
            Yalphabetize::ParsingError,
            "(#{file_path}): found character that cannot start any "\
            'token while scanning for the next token at line 1 column 1'
          )
      end
    end
  end
end
