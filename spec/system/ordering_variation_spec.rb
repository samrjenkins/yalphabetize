# frozen_string_literal: true

RSpec.describe 'ordering variation' do
  context 'when configured to sort by abAB' do
    include_context 'configuration', 'sort_by' => 'abAB'

    it 'registers offence when capitalized come before uncapitalized' do
      expect_offence(<<~YAML)
        Apples: 1
        Bananas: 2
        apples: 3
        bananas: 4
      YAML

      expect_reordering(<<~YAML)
        apples: 3
        bananas: 4
        Apples: 1
        Bananas: 2
      YAML
    end
  end

  context 'when configured to sort by aAbB' do
    include_context 'configuration', 'sort_by' => 'aAbB'

    it 'registers offence when capitalized come before uncapitalized' do
      expect_offence(<<~YAML)
        Apples: 1
        Bananas: 2
        apples: 3
        bananas: 4
      YAML

      expect_reordering(<<~YAML)
        apples: 3
        Apples: 1
        bananas: 4
        Bananas: 2
      YAML
    end
  end

  context 'when configured to sort by AaBb' do
    include_context 'configuration', 'sort_by' => 'AaBb'

    it 'registers offence when capitalized come before uncapitalized' do
      expect_offence(<<~YAML)
        Apples: 1
        Bananas: 2
        apples: 3
        bananas: 4
      YAML

      expect_reordering(<<~YAML)
        Apples: 1
        apples: 3
        Bananas: 2
        bananas: 4
      YAML
    end
  end
end
