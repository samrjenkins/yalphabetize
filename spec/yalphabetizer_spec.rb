require './lib/yalphabetizer'
require 'yaml'

RSpec.describe Yalphabetizer do
  describe ".call" do
    it "alphabetises shallow yaml file" do
      Yalphabetizer.call("spec/fixtures/shallow_test.yml")

      expect(YAML.load_file "./spec/fixtures/shallow_test.yml").to eq(
        {
          "Apples" => 1,
          "Bananas" => 2,
          "Clementines" => 3,
          "Dates" => 4,
          "Eggs" => 5
        }
      )
    end

    it "alphabetises nested yaml file" do
      Yalphabetizer.call("spec/fixtures/nested_test.yml")

      expect(YAML.load_file "./spec/fixtures/nested_test.yml").to eq(
        {
          "Fruit" => {
            "Apples"=>1,
            "Bananas"=>2,
            "Clementines"=>3,
            "Dates"=>4,
            "Eggs" => 5
          },
          "Vegetables" => {
            "Artichokes" => 1,
            "Beans" => 2,
            "Carrots" => 3,
            "Dill" => 4,
            "Eggplant" => 5
          }
        }
      )
    end

    it "does not reorder a list" do
      Yalphabetizer.call("spec/fixtures/array_test.yml")

      expect(YAML.load_file "./spec/fixtures/array_test.yml").to eq(
        ["First", "Second", "Third", "Fourth", "Fifth"]
      )
    end
  end
end

