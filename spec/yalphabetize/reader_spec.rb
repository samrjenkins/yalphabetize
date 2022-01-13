# frozen_string_literal: true

RSpec.describe Yalphabetize::Reader do
  describe '#to_ast' do
    subject { Yalphabetize::Reader.new(file_path).to_ast }

    let(:file_path) { 'spec/fixtures/empty.yml' }

    it { is_expected.to be_a Psych::Nodes::Stream }

    it 'opens and parses the file' do
      expect(File).to receive(:read).with(file_path).and_return('the_file')
      expect(Psych).to receive(:parse_stream).with('the_file').and_return('the_parsed_file')

      expect(subject).to eq 'the_parsed_file'
    end

    context 'when yaml contains invalid syntax' do
      let(:file_path) { 'spec/fixtures/invalid.yml' }

      it do
        expect { subject }.to raise_error(
          Yalphabetize::ParsingError,
          "(#{file_path}): found character that cannot start any "\
          'token while scanning for the next token at line 1 column 1'
        )
      end
    end
  end
end
