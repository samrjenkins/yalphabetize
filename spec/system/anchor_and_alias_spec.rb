# frozen_string_literal: true

RSpec.describe 'anchor and alias' do
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
end
