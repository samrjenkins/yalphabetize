# frozen_string_literal: true

RSpec.describe 'custom ordering' do
  context 'with configured allowed order' do
    include_context 'with configuration', 'allowed_orders' => [%w[zero one two three four five six seven eight nine]]

    it 'when keys match allowed order it sorts according to the configured order' do
      expect_offence(<<~YAML)
        eight: 8
        five: 5
        four: 4
        nine: 9
        one: 1
        seven: 7
        six: 6
        three: 3
        two: 2
        zero: 0
      YAML

      expect_reordering(<<~YAML)
        zero: 0
        one: 1
        two: 2
        three: 3
        four: 4
        five: 5
        six: 6
        seven: 7
        eight: 8
        nine: 9
      YAML
    end

    it 'when keys match subset of allowed order it sorts according to the configured order' do
      expect_offence(<<~YAML)
        one: 1
        three: 3
        two: 2
        zero: 0
      YAML

      expect_reordering(<<~YAML)
        zero: 0
        one: 1
        two: 2
        three: 3
      YAML
    end

    it 'when keys do not match allowed order sorts according to the configured order' do
      expect_no_offences(<<~YAML)
        one: 1
        other: foo
        two: 2
        zero: 0
      YAML
    end
  end

  context 'with configured allowed patterns order' do
    include_context 'with configuration', 'allowed_patterns_orders' => [%w[zero one two three four five six seven eight]]

    it 'when keys match allowed order it sorts according to the configured order' do
      expect_offence(<<~YAML)
        a_string_with_eight_in_it: 8
        a_string_with_five_in_it: 5
        a_string_with_four_in_it: 4
        a_string_with_one_in_it: 1
        a_string_with_seven_in_it: 7
        a_string_with_six_in_it: 6
        a_string_with_three_in_it: 3
        a_string_with_two_in_it: 2
        a_string_with_zero_in_it: 0
      YAML

      expect_reordering(<<~YAML)
        a_string_with_zero_in_it: 0
        a_string_with_one_in_it: 1
        a_string_with_two_in_it: 2
        a_string_with_three_in_it: 3
        a_string_with_four_in_it: 4
        a_string_with_five_in_it: 5
        a_string_with_six_in_it: 6
        a_string_with_seven_in_it: 7
        a_string_with_eight_in_it: 8
      YAML
    end

    it 'when keys match subset of allowed order it sorts according to the configured order' do
      expect_offence(<<~YAML)
        a_string_with_one_in_it: 1
        a_string_with_three_in_it: 3
        a_string_with_two_in_it: 2
        a_string_with_zero_in_it: 0
      YAML

      expect_reordering(<<~YAML)
        a_string_with_zero_in_it: 0
        a_string_with_one_in_it: 1
        a_string_with_two_in_it: 2
        a_string_with_three_in_it: 3
      YAML
    end

    it 'when keys match subset of allowed order and more than one of the keys match the '\
       'same order element it sorts according to the configured order then alphabeticaly' do
      expect_offence(<<~YAML)
        a_string_with_one_in_it: 1
        a_different_string_with_one_in_it: 1
        a_string_with_three_in_it: 3
        a_string_with_two_in_it: 2
        a_string_with_zero_in_it: 0
        a_different_string_with_zero_in_it: 0
      YAML

      expect_reordering(<<~YAML)
        a_different_string_with_zero_in_it: 0
        a_string_with_zero_in_it: 0
        a_different_string_with_one_in_it: 1
        a_string_with_one_in_it: 1
        a_string_with_two_in_it: 2
        a_string_with_three_in_it: 3
      YAML
    end

    it 'when keys do not match allowed order sorts according to the configured order' do
      expect_no_offences(<<~YAML)
        a_string_with_one_in_it: 1
        a_string_with_other_in_it: foo
        a_string_with_two_in_it: 2
        a_string_with_zero_in_it: 0
      YAML
    end
  end
end
