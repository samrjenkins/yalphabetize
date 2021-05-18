# frozen_string_literal: true

require './lib/yalphabetizer'
require 'yaml'

RSpec.describe Yalphabetizer do
  describe '.call' do
    it 'registers offence and corrects alphabetisation for shallow yaml file' do
      expect_offence(<<~YAML)
        Bananas: 2
        Apples: 1
        Dates: 4
        Eggs: 5
        Clementines: 3
      YAML

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

    it 'registers offence and corrects alphabetisation for yaml with ERB interpolation' do
      expect_offence(<<~YAML)
        Bananas: <% a_bit_of_ruby2 %>
        Apples: <% a_bit_of_ruby1 %>
        Dates: <%% a_bit_of_ruby4 %%>
        Clementines: <%# a_bit_of_ruby3 %>
      YAML

      expect_reordering(<<~YAML_ORIGINAL, <<~YAML_FINAL)
        Bananas: <% a_bit_of_ruby2 %>
        Apples: <% a_bit_of_ruby1 %>
        Dates: <%% a_bit_of_ruby4 %%>
        Clementines: <%# a_bit_of_ruby3 %>
      YAML_ORIGINAL
        Apples: <% a_bit_of_ruby1 %>
        Bananas: <% a_bit_of_ruby2 %>
        Clementines: <%# a_bit_of_ruby3 %>
        Dates: <%% a_bit_of_ruby4 %%>
      YAML_FINAL
    end

    it 'registers offence and corrects alphabetisation for yaml with I18n interpolation' do
      expect_offence(<<~YAML)
        Bananas: %{ a_bit_of_ruby2 }
        Apples: %{ a_bit_of_ruby1 }
      YAML

      expect_reordering(<<~YAML_ORIGINAL, <<~YAML_FINAL)
        Bananas: %{ a_bit_of_ruby2 }
        Apples: %{ a_bit_of_ruby1 }
      YAML_ORIGINAL
        Apples: %{ a_bit_of_ruby1 }
        Bananas: %{ a_bit_of_ruby2 }
      YAML_FINAL
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
  end
end

require 'yalphabetize/reader'
require 'yalphabetize/alphabetizer'
require 'yalphabetize/writer'
require 'yalphabetize/offence_detector'
require 'yalphabetize/yaml_finder'
require 'yalphabetize/logger'
require 'yalphabetize/file_yalphabetizer'
require 'yalphabetizer'

def options
  {
    reader_class: Yalphabetize::Reader,
    finder: Yalphabetize::YamlFinder.new,
    alphabetizer_class: Yalphabetize::Alphabetizer,
    writer_class: Yalphabetize::Writer,
    offence_detector_class: Yalphabetize::OffenceDetector,
    logger: Yalphabetize::Logger.new(StringIO.new),
    file_yalphabetizer_class: Yalphabetize::FileYalphabetizer
  }
end

def expect_offence(yaml)
  File.open('spec/tmp/original.yml', 'w') do |file|
    file.write yaml
  end

  expect(Yalphabetizer.call(['spec/tmp'], **options)).to eq 1
end

def expect_no_offences(yaml)
  File.open('spec/tmp/original.yml', 'w') do |file|
    file.write yaml
  end

  expect(Yalphabetizer.call(['spec/tmp'], **options)).to eq 0
end

def expect_reordering(original_yaml, final_yaml)
  File.open('spec/tmp/original.yml', 'w') do |file|
    file.write original_yaml
  end

  Yalphabetizer.call(['spec/tmp', '-a'], **options)

  File.open('spec/tmp/final.yml', 'w') do |file|
    file.write final_yaml
  end

  expect(FileUtils.identical?('spec/tmp/original.yml', 'spec/tmp/final.yml')).to eq true
end

def expect_no_reordering(original_yaml)
  expect_reordering(original_yaml, original_yaml)
end
