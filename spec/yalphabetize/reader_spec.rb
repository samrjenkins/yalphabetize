# frozen_string_literal: true

RSpec.describe Yalphabetize::Reader do
  describe '#to_ast' do
    subject { described_class.new(file_path, handler).to_ast }

    let(:order_checker_class) { Yalphabetize::OrderCheckers::CapitalizedFirstThenAlphabetical }
    let(:handler) { Yalphabetize::Handler.new(order_checker_class) }
    let(:file_path) { 'spec/fixtures/comment.yml' }

    it { is_expected.to be_a Psych::Nodes::Stream }

    context 'when preserve_comments is enabled' do
      include_context 'with configuration', 'preserve_comments' => true

      it 'parses the file with comments' do
        expect(subject).to be_a(Psych::Nodes::Stream).and have_attributes(trailing_comments: ['# comment'], leading_comments: [])
      end
    end

    context 'when preserve_comments is disabled' do
      include_context 'with configuration', 'preserve_comments' => false

      it 'parses the file without comments' do
        expect(subject).to be_a(Psych::Nodes::Stream).and have_attributes(trailing_comments: [], leading_comments: [])
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
