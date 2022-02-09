# frozen_string_literal: true

RSpec::Matchers.define :have_offence do
  match do |yaml|
    File.write('spec/tmp/original.yml', yaml)

    Yalphabetize::CLI.call(['spec/tmp']) == 1
  end
end
