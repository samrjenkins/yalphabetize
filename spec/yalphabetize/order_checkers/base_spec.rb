# frozen_string_literal: true

RSpec.describe Yalphabetize::OrderCheckers::Base do
  describe 'a_subclass.new_for' do
    subject { order_checker_class.new_for(node) }

    let(:order_checker_class) { Class.new(described_class) }
    let(:node) { build(:mapping_node, children: mapping_content) }

    context 'when matching allowed orders' do
      let(:mapping_content) do
        [
          build(:scalar_node, value: 'foo'),
          build(:scalar_node, value: '1'),
          build(:scalar_node, value: 'bar'),
          build(:scalar_node, value: '2'),
          build(:scalar_node, value: 'baz'),
          build(:scalar_node, value: '3')
        ]
      end

      context 'when mapping keys match configured allowed order exactly' do
        include_context 'with configuration', 'allowed_orders' => [%w[foo bar baz]]

        it { is_expected.to be_a Yalphabetize::OrderCheckers::Custom }
      end

      context 'when mapping keys match configured allowed order but are not in the specified order' do
        include_context 'with configuration', 'allowed_orders' => [%w[bar foo baz]]

        it { is_expected.to be_a Yalphabetize::OrderCheckers::Custom }
      end

      context 'when mapping keys match subset of configured allowed order exactly' do
        include_context 'with configuration', 'allowed_orders' => [%w[foo bar baz bing]]

        it { is_expected.to be_a Yalphabetize::OrderCheckers::Custom }
      end

      context 'when mapping keys match subset of configured allowed order but are not in the specified order' do
        include_context 'with configuration', 'allowed_orders' => [%w[foo baz bar bing]]

        it { is_expected.to be_a Yalphabetize::OrderCheckers::Custom }
      end

      context 'when mapping keys match configured allowed order but with extra keys' do
        include_context 'with configuration', 'allowed_orders' => [%w[foo bar]]

        it { is_expected.to be_a order_checker_class }
      end

      context 'when mapping keys match subset of configured allowed order but with extra keys' do
        include_context 'with configuration', 'allowed_orders' => [%w[foo bar bing]]

        it { is_expected.to be_a order_checker_class }
      end
    end

    context 'when matching allowed patterns orders' do
      let(:mapping_content) do
        [
          build(:scalar_node, value: 'a_foo_pattern'),
          build(:scalar_node, value: '1'),
          build(:scalar_node, value: 'a_bar_pattern'),
          build(:scalar_node, value: '2'),
          build(:scalar_node, value: 'a_baz_pattern'),
          build(:scalar_node, value: '3')
        ]
      end

      context 'when mapping keys match configured allowed order exactly' do
        include_context 'with configuration', 'allowed_patterns_orders' => [%w[foo bar baz]]

        it { is_expected.to be_a Yalphabetize::OrderCheckers::CustomPattern }
      end

      context 'when mapping keys match configured allowed order but are not in the specified order' do
        include_context 'with configuration', 'allowed_patterns_orders' => [%w[bar foo baz]]

        it { is_expected.to be_a Yalphabetize::OrderCheckers::CustomPattern }
      end

      context 'when mapping keys match subset of configured allowed order exactly' do
        include_context 'with configuration', 'allowed_patterns_orders' => [%w[foo bar baz bing]]

        it { is_expected.to be_a Yalphabetize::OrderCheckers::CustomPattern }
      end

      context 'when mapping keys match subset of configured allowed order but are not in the specified order' do
        include_context 'with configuration', 'allowed_patterns_orders' => [%w[foo baz bar bing]]

        it { is_expected.to be_a Yalphabetize::OrderCheckers::CustomPattern }
      end

      context 'when mapping keys match configured allowed order but with extra keys' do
        include_context 'with configuration', 'allowed_patterns_orders' => [%w[foo bar]]

        it { is_expected.to be_a order_checker_class }
      end

      context 'when mapping keys match subset of configured allowed order but with extra keys' do
        include_context 'with configuration', 'allowed_patterns_orders' => [%w[foo bar bing]]

        it { is_expected.to be_a order_checker_class }
      end
    end

    context 'when node keys match an allowed order and an allowed patterns order' do
      include_context 'with configuration',
                      'allowed_orders' => [%w[foo bar baz]],
                      'allowed_patterns_orders' => [%w[foo bar baz]]

      let(:mapping_content) do
        [
          build(:scalar_node, value: 'foo'),
          build(:scalar_node, value: '1'),
          build(:scalar_node, value: 'bar'),
          build(:scalar_node, value: '2'),
          build(:scalar_node, value: 'baz'),
          build(:scalar_node, value: '3')
        ]
      end

      it { is_expected.to be_a Yalphabetize::OrderCheckers::Custom }
    end
  end
end
