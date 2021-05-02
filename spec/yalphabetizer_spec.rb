require './lib/yalphabetizer'
require 'yaml'

RSpec.describe Yalphabetizer do
  describe ".call" do
    it "alphabetises shallow yaml file" do
      expect_reordering(<<~YAML_ORIGINAL, <<~YAML_FINAL)
        Bananas: 2
        Apples: 1
        Dates: 4
        Eggs: 5
        Clementines: 3
      YAML_ORIGINAL
        Apples: 1
        Bananas: 2
        Clementines: 3
        Dates: 4
        Eggs: 5
      YAML_FINAL
    end

    it "alphabetises nested yaml file" do
      expect_reordering(<<~YAML_ORIGINAL, <<~YAML_FINAL)
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
      YAML_ORIGINAL
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
      YAML_FINAL
    end

    it "alphabetises heavily nested yaml" do
      expect_reordering(<<~YAML_ORIGINAL, <<~YAML_FINAL)
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
      YAML_ORIGINAL
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
      YAML_FINAL
    end

    it "does not reorder a list" do
      expect_no_reordering(<<~YAML)
        - First
        - Second
        - Third
        - Fourth
        - Fifth
      YAML
    end
  end
end

def expect_reordering(original_yaml, final_yaml)
  FileUtils.remove_dir("spec/tmp", true) if Dir.exist?("spec/tmp")

  Dir.mkdir("spec/tmp")

  File.open("spec/tmp/original.yml", 'w') do |file|
    file.write original_yaml
  end

  File.open("spec/tmp/final.yml", 'w') do |file|
    file.write final_yaml
  end

  Yalphabetizer.call("spec/tmp/original.yml")

  expect(FileUtils.identical?("spec/tmp/original.yml", "spec/tmp/final.yml")).to eq true

  FileUtils.remove_dir("spec/tmp", true)
end

def expect_no_reordering(original_yaml)
  expect_reordering(original_yaml, original_yaml)
end
