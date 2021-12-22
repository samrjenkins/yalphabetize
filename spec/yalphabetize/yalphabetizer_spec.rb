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

    context 'with config but config has not configured `excluded`' do
      include_context 'configuration', 'other_config' => 'foo'

      it 'calls YamlFinder with only and exclude empty' do
        expect(Yalphabetize::YamlFinder).to receive(:paths).with(only: [], exclude: []).and_return []
        subject
      end
    end

    context 'with excluded config' do
      include_context 'configuration', 'exclude' => ['bar']

      it 'calls YamlFinder with only empty and exclude with value from config' do
        expect(Yalphabetize::YamlFinder).to receive(:paths).with(only: [], exclude: ['bar']).and_return []
        subject
      end
    end
  end
end
