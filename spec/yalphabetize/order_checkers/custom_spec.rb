# frozen_string_literal: true

RSpec.describe Yalphabetize::OrderCheckers::Custom do
  subject { described_class.new(allowed_order).compare(string, other_string) }

  let(:allowed_order) { %w[one two three] }

  context 'when comparing one with one' do
    let(:string) { 'one' }
    let(:other_string) { 'one' }

    it { is_expected.to eq(0) }
  end

  context 'when comparing one with two' do
    let(:string) { 'one' }
    let(:other_string) { 'two' }

    it { is_expected.to eq(-1) }
  end

  context 'when comparing one with three' do
    let(:string) { 'one' }
    let(:other_string) { 'three' }

    it { is_expected.to eq(-1) }
  end

  context 'when comparing two with one' do
    let(:string) { 'two' }
    let(:other_string) { 'one' }

    it { is_expected.to eq(1) }
  end

  context 'when comparing two with two' do
    let(:string) { 'two' }
    let(:other_string) { 'two' }

    it { is_expected.to eq(0) }
  end

  context 'when comparing two with three' do
    let(:string) { 'two' }
    let(:other_string) { 'three' }

    it { is_expected.to eq(-1) }
  end

  context 'when comparing three with one' do
    let(:string) { 'three' }
    let(:other_string) { 'one' }

    it { is_expected.to eq(1) }
  end

  context 'when comparing three with two' do
    let(:string) { 'three' }
    let(:other_string) { 'two' }

    it { is_expected.to eq(1) }
  end

  context 'when comparing three with three' do
    let(:string) { 'three' }
    let(:other_string) { 'three' }

    it { is_expected.to eq(0) }
  end
end
