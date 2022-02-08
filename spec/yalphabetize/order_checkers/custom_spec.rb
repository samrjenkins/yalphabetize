# frozen_string_literal: true

RSpec.describe Yalphabetize::OrderCheckers::Custom do
  subject { described_class.new(allowed_order).compare(string, other_string) }

  let(:allowed_order) { %w[one two three] }

  context do
    let(:string) { 'one' }
    let(:other_string) { 'one' }

    it { is_expected.to eq(0) }
  end

  context do
    let(:string) { 'one' }
    let(:other_string) { 'two' }

    it { is_expected.to eq(-1) }
  end

  context do
    let(:string) { 'one' }
    let(:other_string) { 'three' }

    it { is_expected.to eq(-1) }
  end

  context do
    let(:string) { 'two' }
    let(:other_string) { 'one' }

    it { is_expected.to eq(1) }
  end

  context do
    let(:string) { 'two' }
    let(:other_string) { 'two' }

    it { is_expected.to eq(0) }
  end

  context do
    let(:string) { 'two' }
    let(:other_string) { 'three' }

    it { is_expected.to eq(-1) }
  end

  context do
    let(:string) { 'three' }
    let(:other_string) { 'one' }

    it { is_expected.to eq(1) }
  end

  context do
    let(:string) { 'three' }
    let(:other_string) { 'two' }

    it { is_expected.to eq(1) }
  end

  context do
    let(:string) { 'three' }
    let(:other_string) { 'three' }

    it { is_expected.to eq(0) }
  end
end
