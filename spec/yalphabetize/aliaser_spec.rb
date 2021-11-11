# frozen_string_literal: true

require './lib/yalphabetize/aliaser'

RSpec.describe Yalphabetize::Aliaser do
  describe '#call' do
    subject { described_class.new(node).call }

    let(:alias_node) { build(:alias_node, anchor: 'anchor') }
    let(:scalar_node) { build(:scalar_node, anchor: 'anchor', value: 'anchor_value') }

    context 'when alias comes before anchor' do
      let(:node) { build(:document_node, children: [alias_node, scalar_node]) }

      it do
        expect { subject }.to change(node, :children).from([alias_node, scalar_node]).to([scalar_node, alias_node])
      end
    end

    context 'when alias comes after anchor' do
      let(:node) { build(:document_node, children: [scalar_node, alias_node]) }

      it do
        expect { subject }.to_not change(node, :children).from([scalar_node, alias_node])
      end
    end
  end
end
