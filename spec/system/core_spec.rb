# frozen_string_literal: true

RSpec.describe 'core' do
  it 'accepts alphabetised shallow yaml file' do
    expect_no_offences(<<~YAML)
      Apples: 1
      Bananas: 2
      Clementines: 3
      Dates: 4
      Eggs: 5
    YAML
  end

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
end
