# frozen_string_literal: true

RSpec.describe Yalphabetize::Yalphabetizer do
  describe '.call' do
    subject { described_class.call(args, opts) }

    let(:args) { [] }
    let(:opts) { {} }

    context 'without config' do
      it 'calls YamlFinder with only and exclude empty' do
        expect(Yalphabetize::YamlFinder).to receive(:paths).with(only: [], exclude: []).and_return []
        subject
      end
    end

    context 'with only config' do
      include_context 'with configuration', 'only' => ['foo']

      it 'calls YamlFinder with exclude empty and only with value from config' do
        expect(Yalphabetize::YamlFinder).to receive(:paths).with(only: ['foo'], exclude: []).and_return []
        subject
      end

      context 'when file paths provided as args' do
        let(:args) { ['bar'] }

        it 'calls YamlFinder with only value from args' do
          expect(Yalphabetize::YamlFinder).to receive(:paths).with(only: ['bar'], exclude: []).and_return []
          subject
        end
      end
    end

    context 'with excluded config' do
      include_context 'with configuration', 'exclude' => ['baz']

      it 'calls YamlFinder with only empty and exclude with value from config' do
        expect(Yalphabetize::YamlFinder).to receive(:paths).with(only: [], exclude: ['baz']).and_return []
        subject
      end
    end
  end
end
