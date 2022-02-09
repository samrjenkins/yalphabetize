# frozen_string_literal: true

RSpec.describe Yalphabetize do
  describe '.config' do
    subject { described_class.config }

    let(:expected_default_config) do
      {
        'indent_sequences' => true,
        'exclude' => [],
        'only' => [],
        'sort_by' => 'ABab'
      }
    end

    context 'without yaml config' do
      it { is_expected.to eq expected_default_config }
    end

    context 'with empty yaml config' do
      include_context 'with configuration'

      it { is_expected.to eq expected_default_config }
    end

    context 'with yaml config' do
      include_context 'with configuration', 'exclude' => 'foo', 'only' => 'bar'

      it { is_expected.to eq(expected_default_config.merge({ 'exclude' => 'foo', 'only' => 'bar' })) }
    end
  end
end
