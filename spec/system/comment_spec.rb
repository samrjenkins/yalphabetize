# frozen_string_literal: true

RSpec.describe 'comment' do
  it 'autocorrect does nothing to # literals in strings' do
    expect_offence(<<~YAML)
      Bananas: '2 # not a comment 2'
      Apples: '1 # not a comment 1'
    YAML

    expect_reordering(<<~YAML)
      Apples: '1 # not a comment 1'
      Bananas: '2 # not a comment 2'
    YAML
  end

  it 'autocorrect preserves newline comments above the proceeding YAML' do
    expect_offence(<<~YAML)
      # Bananas comment 1
      # Bananas comment 2
      Bananas: 2
      # Apples comment 1
      # Apples comment 2
      Apples: 1
    YAML

    expect_reordering(<<~YAML)
      # Apples comment 1
      # Apples comment 2
      Apples: 1
      # Bananas comment 1
      # Bananas comment 2
      Bananas: 2
    YAML
  end

  it 'autocorrect preserves newline comments before the start of a doc' do
    expect_offence(<<~YAML)
      # Comment 1
      # Comment 2
      ---
      Bananas: 2
      Apples: 1
    YAML

    expect_reordering(<<~YAML)
      # Comment 1
      # Comment 2
      ---
      Apples: 1
      Bananas: 2
    YAML
  end

  it 'autocorrect preserves newline comments before end of a doc' do
    expect_offence(<<~YAML)
      Bananas: 2
      Apples: 1
      # Comment 1
      # Comment 2
    YAML

    expect_reordering(<<~YAML)
      Apples: 1
      Bananas: 2
      # Comment 1
      # Comment 2
    YAML
  end

  it 'autocorrect preserved newline comments after end of a doc' do
    expect_offence(<<~YAML)
      Bananas: 2
      Apples: 1
      ...
      # Comment 1
      # Comment 2
    YAML

    expect_reordering(<<~YAML)
      Apples: 1
      Bananas: 2
      ...
      # Comment 1
      # Comment 2
    YAML
  end
end
