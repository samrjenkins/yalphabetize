# frozen_string_literal: true

RSpec.describe Yalphabetize do
  describe '.config' do
    subject { described_class.config }

    context 'without yaml config' do
      it { is_expected.to eq({ 'exclude' => [], 'only' => [], 'sort_by' => 'ABab' }) }
    end

    context 'with empty yaml config' do
      include_context 'configuration'

      it { is_expected.to eq({ 'exclude' => [], 'only' => [], 'sort_by' => 'ABab' }) }
    end

    context 'with yaml config' do
      include_context 'configuration', 'exclude' => 'foo', 'only' => 'bar', 'sort_by' => 'baz'

      it { is_expected.to eq({ 'exclude' => 'foo', 'only' => 'bar', 'sort_by' => 'baz' }) }
    end
  end
end
