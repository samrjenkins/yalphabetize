# frozen_string_literal: true

RSpec.describe Yalphabetize::OrderCheckers do
  describe '::TOKEN_MAPPING[token]' do
    subject { described_class::TOKEN_MAPPING[token] }

    context 'when AaBb token provided' do
      let(:token) { 'AaBb' }

      it { is_expected.to eq Yalphabetize::OrderCheckers::AlphabeticalThenCapitalizedFirst }
    end

    context 'when aAbB token provided' do
      let(:token) { 'aAbB' }

      it { is_expected.to eq Yalphabetize::OrderCheckers::AlphabeticalThenCapitalizedLast }
    end

    context 'when ABab token provided' do
      let(:token) { 'ABab' }

      it { is_expected.to eq Yalphabetize::OrderCheckers::CapitalizedFirstThenAlphabetical }
    end

    context 'when abAB token provided' do
      let(:token) { 'abAB' }

      it { is_expected.to eq Yalphabetize::OrderCheckers::CapitalizedLastThenAlphabetical }
    end
  end
end
