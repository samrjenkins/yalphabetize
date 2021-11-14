# frozen_string_literal: true

require './lib/yalphabetize/cli'

RSpec.describe Yalphabetize::CLI do
  describe '.call' do
    subject { described_class.call(argv) }

    context 'when ARGV is empty' do
      let(:argv) { [] }

      it 'calls yalphabetizer with empty array and options hash' do
        expect(Yalphabetize::Yalphabetizer).to receive(:call).with([], {})
        subject
      end
    end

    context 'when ARGV is not empty' do
      let(:argv) { %w[arg1 arg2] }

      it 'calls yalphabetizer with those arguments' do
        expect(Yalphabetize::Yalphabetizer).to receive(:call).with(%w[arg1 arg2], {})
        subject
      end
    end

    context 'when ARGV contains -a switch' do
      let(:argv) { %w[-a] }

      it 'calls yalphabetizer with autocorrect option' do
        expect(Yalphabetize::Yalphabetizer).to receive(:call).with([], { autocorrect: true })
        subject
      end
    end

    context 'when ARGV contains --autocorrect switch' do
      let(:argv) { %w[--autocorrect] }

      it 'calls yalphabetizer with autocorrect option' do
        expect(Yalphabetize::Yalphabetizer).to receive(:call).with([], { autocorrect: true })
        subject
      end
    end

    context 'when ARGV contains arguments and options' do
      let(:argv) { %w[arg1 arg2 -a] }

      it 'calls yalphabetizer with correct arguments and options' do
        expect(Yalphabetize::Yalphabetizer).to receive(:call).with(%w[arg1 arg2], { autocorrect: true })
        subject
      end
    end
  end
end
