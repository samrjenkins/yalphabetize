# frozen_string_literal: true

RSpec.describe Yalphabetize::OrderCheckers::CustomPattern do
  subject { described_class.new(allowed_order).compare(string, other_string) }

  let(:allowed_order) { %w[.*one.* .*two.* .*three.*] }

  context 'when comparing one with one' do
    let(:string) { 'a_string_with_one_in_it' }
    let(:other_string) { 'a_string_with_one_in_it' }

    it { is_expected.to eq(0) }
  end

  context 'when comparing one with two' do
    let(:string) { 'a_string_with_one_in_it' }
    let(:other_string) { 'a_string_with_two_in_it' }

    it { is_expected.to eq(-1) }
  end

  context 'when comparing one with three' do
    let(:string) { 'a_string_with_one_in_it' }
    let(:other_string) { 'a_string_with_three_in_it' }

    it { is_expected.to eq(-1) }
  end

  context 'when comparing two with one' do
    let(:string) { 'a_string_with_two_in_it' }
    let(:other_string) { 'a_string_with_one_in_it' }

    it { is_expected.to eq(1) }
  end

  context 'when comparing two with two' do
    let(:string) { 'a_string_with_two_in_it' }
    let(:other_string) { 'a_string_with_two_in_it' }

    it { is_expected.to eq(0) }
  end

  context 'when comparing two with three' do
    let(:string) { 'a_string_with_two_in_it' }
    let(:other_string) { 'a_string_with_three_in_it' }

    it { is_expected.to eq(-1) }
  end

  context 'when comparing three with one' do
    let(:string) { 'a_string_with_three_in_it' }
    let(:other_string) { 'a_string_with_one_in_it' }

    it { is_expected.to eq(1) }
  end

  context 'when comparing three with two' do
    let(:string) { 'a_string_with_three_in_it' }
    let(:other_string) { 'a_string_with_two_in_it' }

    it { is_expected.to eq(1) }
  end

  context 'when comparing three with three' do
    let(:string) { 'a_string_with_three_in_it' }
    let(:other_string) { 'a_string_with_three_in_it' }

    it { is_expected.to eq(0) }
  end

  context 'when comparing a_string_with_three_in_it with a_different_string_with_three_in_it' do
    let(:string) { 'a_string_with_three_in_it' }
    let(:other_string) { 'a_different_string_with_three_in_it' }

    it { is_expected.to eq(1) }
  end

  context 'when comparing a_string_with_three_in_it with a_different_string_with_three_in_it' do
    let(:string) { 'a_different_string_with_three_in_it' }
    let(:other_string) { 'a_string_with_three_in_it' }

    it { is_expected.to eq(-1) }
  end
end
