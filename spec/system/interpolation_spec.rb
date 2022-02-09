# frozen_string_literal: true

RSpec.describe 'interpolation' do
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
      Bananas: '%{ a_bit_of_ruby2 }'
      Apples: '%{ a_bit_of_ruby1 }'
    YAML

    expect_reordering(<<~YAML)
      Apples: '%{ a_bit_of_ruby1 }'
      Bananas: '%{ a_bit_of_ruby2 }'
    YAML
  end

  it 'registers offence and corrects alphabetisation for yaml with `{{ }}` interpolation' do
    expect_offence(<<~YAML)
      Bananas: '{{ a_bit_of_ruby2 }}'
      Apples: '{{ a_bit_of_ruby1 }}'
    YAML

    expect_reordering(<<~YAML)
      Apples: '{{ a_bit_of_ruby1 }}'
      Bananas: '{{ a_bit_of_ruby2 }}'
    YAML
  end
end
