# frozen_string_literal: true

RSpec.describe Yalphabetize::Alphabetizer do
  describe '#call' do
    subject { described_class.new(node, order_checker_class: order_checker_class).call }

    let(:order_checker_class) { Yalphabetize::OrderCheckers::DEFAULT }

    context 'when node is already alphabetized' do
      let(:node) do
        build(
          :mapping_node,
          children: [
            build(:scalar_node, value: 'apples'),
            build(:scalar_node, value: 1),
            build(:scalar_node, value: 'bananas'),
            build(:scalar_node, value: 2)
          ]
        )
      end

      it 'does not change the node' do
        expect { subject }.not_to change(node, :children)
      end

      context 'when provided with nested mappings' do
        let(:node) do
          build(
            :mapping_node,
            children: [
              build(:scalar_node, value: 'apples'),
              build(:scalar_node, value: 1),
              build(:scalar_node, value: 'bananas'),
              build(:scalar_node, value: 2),
              build(:scalar_node, value: 'cars'),
              build(
                :mapping_node,
                children: [
                  build(:scalar_node, value: 'alfa_romeo'),
                  build(:scalar_node, value: 1),
                  build(:scalar_node, value: 'bugatti'),
                  build(:scalar_node, value: 2)
                ]
              )
            ]
          )
        end

        it 'alphabetizes the node' do
          expect { subject }.not_to change(node, :children)
        end
      end
    end

    context 'when node is not already alphabetized' do
      let(:node) do
        build(
          :mapping_node,
          children: [
            build(:scalar_node, value: 'bananas'),
            build(:scalar_node, value: 2),
            build(:scalar_node, value: 'apples'),
            build(:scalar_node, value: 1)
          ]
        )
      end

      it 'alphabetizes the node' do
        expect { subject }.to change(node, :children)
      end

      context 'when provided with nested mappings' do
        let(:node) do
          build(
            :mapping_node,
            children: [
              build(:scalar_node, value: 'bananas'),
              build(:scalar_node, value: 2),
              build(:scalar_node, value: 'apples'),
              build(:scalar_node, value: 1),
              build(:scalar_node, value: 'cars'),
              build(
                :mapping_node,
                children: [
                  build(:scalar_node, value: 'bugatti'),
                  build(:scalar_node, value: 2),
                  build(:scalar_node, value: 'alfa_romeo'),
                  build(:scalar_node, value: 1)
                ]
              )
            ]
          )
        end

        it 'alphabetizes the node' do
          expect { subject }.to change(node, :children)
        end
      end
    end
  end
end
