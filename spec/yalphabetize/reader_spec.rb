# frozen_string_literal: true

RSpec.describe Yalphabetize::Reader do
  describe '#to_ast' do
    subject { described_class.new(file_path).to_ast }

    let(:file_path) { 'spec/fixtures/empty.yml' }

    it { is_expected.to be_a Psych::Nodes::Stream }

    context 'when preserve_comments is enabled' do
      include_context 'with configuration', 'preserve_comments' => true

      it 'opens and parses the file' do
        expect(File).to receive(:read).with(file_path).and_return('the_file')
        expect(Psych::Comments).to receive(:parse_stream).with('the_file').and_return('the_parsed_file_with_comments')

        expect(subject).to eq 'the_parsed_file_with_comments'
      end
    end

    context 'when preserve_comments is disabled' do
      include_context 'with configuration', 'preserve_comments' => false

      it 'opens and parses the file' do
        expect(File).to receive(:read).with(file_path).and_return('the_file')
        expect(Psych).to receive(:parse_stream).with('the_file').and_return('the_parsed_file_without_comments')

        expect(subject).to eq 'the_parsed_file_without_comments'
      end
    end

    context 'when yaml contains parseable i18n interpolations' do
      let(:file_path) { 'spec/fixtures/parseable_interpolations.yml' }

      it { is_expected.to be_a Psych::Nodes::Stream }
    end

    context 'when yaml contains unparseable i18n interpolation' do
      let(:file_path) { 'spec/fixtures/unparseable_i18n_interpolation.yml' }

      it do
        expect { subject }.to raise_error(
          Yalphabetize::ParsingError,
          "(#{file_path}): found character that cannot start any " \
          'token while scanning for the next token at line 1 column 9'
        )
      end
    end
  end
end
