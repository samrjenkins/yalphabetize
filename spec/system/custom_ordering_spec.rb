# frozen_string_literal: true

RSpec.describe 'custom ordering' do
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
