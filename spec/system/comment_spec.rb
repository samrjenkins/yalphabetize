# frozen_string_literal: true

RSpec.describe 'comment' do
  it 'autocorrect preserves inline comments' do
    expect_offence(<<~YAML)
      Bananas: 2 # comment 2
      Apples: 1 # comment 1
    YAML

    expect_reordering(<<~YAML)
      Apples: 1 # comment 1
      Bananas: 2 # comment 2
    YAML
  end

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

  it 'autocorrect handles many "#"s on the same line' do
    expect_offence(<<~YAML)
      Bananas: '#2' # comment #2
      Apples: '#1' # comment #1
    YAML

    expect_reordering(<<~YAML)
      Apples: '#1' # comment #1
      Bananas: '#2' # comment #2
    YAML
  end

  it 'autocorrect leaves newline comments above the proceeding YAML' do
    expect_offence(<<~YAML)
      # comment 2
      Bananas: 2
      # comment 1
      Apples: 1
    YAML

    expect_reordering(<<~YAML)
      # comment 1
      Apples: 1
      # comment 2
      Bananas: 2
    YAML
  end

  it 'autocorrect leaves newline comments at the end of a doc' do
    expect_offence(<<~YAML)
      Bananas: 2
      Apples: 1
      # comment
    YAML

    expect_reordering(<<~YAML)
      Apples: 1
      Bananas: 2
      # comment
    YAML
  end

  it 'correctly preserves comments in a more complex reordering case' do
      expect_offence(<<~YAML)
        # comment3
        Bananas: 'string # not a comment2' # comment4
        # comment1
        Apples: string# not a comment1 # comment2
        Clementines: | # comment5
          string # not a comment3
          # not a comment4
          hi # not a comment5
          # not a comment6
        #comment6
      YAML

      expect_reordering(<<~YAML)
        # comment1
        Apples: string# not a comment1 # comment2
        # comment3
        Bananas: 'string # not a comment2' # comment4
        Clementines: | # comment5
          string # not a comment3
          # not a comment4
          hi # not a comment5
          # not a comment6
        #comment6
      YAML
    end
end
