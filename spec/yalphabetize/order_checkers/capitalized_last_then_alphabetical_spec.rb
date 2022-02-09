# frozen_string_literal: true

RSpec.describe Yalphabetize::OrderCheckers::CapitalizedLastThenAlphabetical do
  subject { described_class.new.compare(string, other_string) }

  context 'when both strings are identical uppercase' do
    let(:string) { 'A' }
    let(:other_string) { 'A' }

    it { is_expected.to eq(0) }
  end

  context 'when both strings are identical lowercase' do
    let(:string) { 'a' }
    let(:other_string) { 'a' }

    it { is_expected.to eq(0) }
  end

  context 'when first string is uppercase and second is lowercase of the same letter' do
    let(:string) { 'A' }
    let(:other_string) { 'a' }

    it { is_expected.to eq(1) }
  end

  context 'when first string is lowercase and second is uppercase of the same letter' do
    let(:string) { 'a' }
    let(:other_string) { 'A' }

    it { is_expected.to eq(-1) }
  end

  context 'when first string is alphabetically before the second and both are uppercase' do
    let(:string) { 'A' }
    let(:other_string) { 'B' }

    it { is_expected.to eq(-1) }
  end

  context 'when first string is alphabetically before the second and both are lowercase' do
    let(:string) { 'a' }
    let(:other_string) { 'b' }

    it { is_expected.to eq(-1) }
  end

  context 'when first string is alphabetically after the second and both are lowercase' do
    let(:string) { 'b' }
    let(:other_string) { 'a' }

    it { is_expected.to eq(1) }
  end

  context 'when first string is alphabetically after the second and both are uppercase' do
    let(:string) { 'B' }
    let(:other_string) { 'A' }

    it { is_expected.to eq(1) }
  end

  context 'when first string is alphabetically after the second, first is uppercase, second is lowercase' do
    let(:string) { 'B' }
    let(:other_string) { 'a' }

    it { is_expected.to eq(1) }
  end

  context 'when first string is alphabetically before the second, first is uppercase, second is lowercase' do
    let(:string) { 'A' }
    let(:other_string) { 'b' }

    it { is_expected.to eq(1) }
  end

  context 'when first string is alphabetically before the second, first is lowercase, second is uppercase' do
    let(:string) { 'a' }
    let(:other_string) { 'B' }

    it { is_expected.to eq(-1) }
  end

  context 'when first string is alphabetically after the second, first is lowercase, second is uppercase' do
    let(:string) { 'b' }
    let(:other_string) { 'A' }

    it { is_expected.to eq(-1) }
  end
end
