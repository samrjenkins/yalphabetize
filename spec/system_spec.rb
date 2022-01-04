# frozen_string_literal: true

RSpec.describe 'system' do
  it 'registers offence and corrects alphabetisation for shallow yaml file' do
    expect_offence(<<~YAML)
      Bananas: 2
      Apples: 1
      Dates: 4
      Eggs: 5
      Clementines: 3
    YAML

    expect_reordering(<<~YAML)
      Apples: 1
      Bananas: 2
      Clementines: 3
      Dates: 4
      Eggs: 5
    YAML
  end

  it 'accepts alphabetised shallow yaml file' do
    expect_no_offences(<<~YAML)
      Apples: 1
      Bananas: 2
      Clementines: 3
      Dates: 4
      Eggs: 5
    YAML
  end

  it 'registers offence and corrects alphabetisation for nested yaml file' do
    expect_offence(<<~YAML)
      Vegetables:
        Artichokes: 1
        Carrots: 3
        Beans: 2
        Eggplant: 5
        Dill: 4
      Fruit:
        Dates: 4
        Bananas: 2
        Clementines: 3
        Eggs: 5
        Apples: 1
    YAML

    expect_reordering(<<~YAML)
      Fruit:
        Apples: 1
        Bananas: 2
        Clementines: 3
        Dates: 4
        Eggs: 5
      Vegetables:
        Artichokes: 1
        Beans: 2
        Carrots: 3
        Dill: 4
        Eggplant: 5
    YAML
  end

  it 'registers offence and corrects alphabetisation for heavily nested yaml file' do
    expect_offence(<<~YAML)
      Vehicles:
        Bikes:
          Honda: 2
          Bmw: 1
          Yamaha: 3
        Spaceship: 3
        Cars:
          Ferrari: 1
          Ford: 2
          Volvo: 3
      Food:
        Fruit:
          Apples: 1
          Clementines: 3
          Bananas: 2
          Eggs: 5
          Dates: 4
        Chocolate: 1
        Vegetables:
          Beans: 2
          Carrots: 3
          Dill: 4
          Artichokes: 1
          Eggplant: 5
    YAML

    expect_reordering(<<~YAML)
      Food:
        Chocolate: 1
        Fruit:
          Apples: 1
          Bananas: 2
          Clementines: 3
          Dates: 4
          Eggs: 5
        Vegetables:
          Artichokes: 1
          Beans: 2
          Carrots: 3
          Dill: 4
          Eggplant: 5
      Vehicles:
        Bikes:
          Bmw: 1
          Honda: 2
          Yamaha: 3
        Cars:
          Ferrari: 1
          Ford: 2
          Volvo: 3
        Spaceship: 3
    YAML
  end

  it 'registers offence and corrects alphabetisation for yaml with ERB interpolation' do
    expect_offence(<<~YAML)
      Bananas: <%= a_bit_of_ruby2 %>
      Apples: <% a_bit_of_ruby1 %>
      Dates: <%% a_bit_of_ruby4 %%>
      Clementines: <%# a_bit_of_ruby3 %>
    YAML

    expect_reordering(<<~YAML)
      Apples: <% a_bit_of_ruby1 %>
      Bananas: <%= a_bit_of_ruby2 %>
      Clementines: <%# a_bit_of_ruby3 %>
      Dates: <%% a_bit_of_ruby4 %%>
    YAML
  end

  it 'registers offence and corrects alphabetisation for yaml with I18n interpolation' do
    expect_offence(<<~YAML)
      Bananas: %{ a_bit_of_ruby2 }
      Apples: %{ a_bit_of_ruby1 }
    YAML

    expect_reordering(<<~YAML)
      Apples: %{ a_bit_of_ruby1 }
      Bananas: %{ a_bit_of_ruby2 }
    YAML
  end

  it 'registers offence and corrects alphabetisation for yaml with `{{  }}` interpolation' do
    expect_offence(<<~YAML)
      Bananas: {{ a_bit_of_ruby2 }}
      Apples: {{ a_bit_of_ruby1 }}
    YAML

    expect_reordering(<<~YAML)
      Apples: {{ a_bit_of_ruby1 }}
      Bananas: {{ a_bit_of_ruby2 }}
    YAML
  end

  it 'does not reorder a list' do
    expect_no_reordering(<<~YAML)
      - First
      - Second
      - Third
      - Fourth
      - Fifth
    YAML
  end

  it 'swaps anchor and alias when necessary' do
    expect_offence(<<~YAML)
      Bananas: &shared
        shared1: 1
      Apples: *shared
    YAML

    expect_reordering(<<~YAML)
      Apples: &shared
        shared1: 1
      Bananas: *shared
    YAML
  end

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
