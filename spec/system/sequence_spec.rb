# frozen_string_literal: true

RSpec.describe 'sequence' do
  it 'does not reorder a sequence' do
    expect_no_reordering(<<~YAML)
      - First
      - Second
      - Third
      - Fourth
      - Fifth
    YAML
  end

  it 'preserves sequence indentation' do
    expect_offence(<<~YAML)
      - Vegeatables:
          - Aubergines
          - Beans
        Fruit:
          - Apples
          - Bananas
    YAML

    expect_reordering(<<~YAML)
      - Fruit:
          - Apples
          - Bananas
        Vegeatables:
          - Aubergines
          - Beans
    YAML
  end

  context 'when configured to not indent sequences' do
    include_context 'configuration', 'indent_sequences' => false

    it 'preserves sequence indentation' do
      expect_offence(<<~YAML)
        - Vegeatables:
          - Aubergines
          - Beans
          Fruit:
          - Apples
          - Bananas
      YAML

      expect_reordering(<<~YAML)
        - Fruit:
          - Apples
          - Bananas
          Vegeatables:
          - Aubergines
          - Beans
      YAML
    end
  end
end
