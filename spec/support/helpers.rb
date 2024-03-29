# frozen_string_literal: true

require 'fileutils'

module Helpers
  def create_file(file_path, content)
    file_path = File.expand_path("spec/tmp/#{file_path}")

    dir_path = File.dirname(file_path)
    FileUtils.makedirs dir_path

    File.open(file_path, 'w') do |file|
      file.puts content
    end

    file_path
  end

  def create_empty_file(file_path)
    create_file(file_path, '')
  end

  def expect_offence(yaml)
    expect(yaml).to have_offence
  end

  def expect_no_offences(yaml)
    expect(yaml).not_to have_offence
  end

  def expect_reordering(yaml)
    Yalphabetize::CLI.call(['spec/tmp', '-a'])

    File.write('spec/tmp/final.yml', yaml)

    original = File.read 'spec/tmp/original.yml'
    final = File.read 'spec/tmp/final.yml'

    expect(original).to eq final
  end

  def expect_no_reordering(yaml)
    File.write('spec/tmp/original.yml', yaml)

    expect_reordering(yaml)
  end
end
