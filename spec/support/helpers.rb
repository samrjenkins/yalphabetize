# frozen_string_literal: true

require 'fileutils'

module Helpers
  def create_file(file_path, content)
    file_path = File.expand_path("spec/tmp/#{file_path}")

    dir_path = File.dirname(file_path)
    FileUtils.makedirs dir_path unless File.exist?(dir_path)

    File.open(file_path, 'w') do |file|
      case content
      when String
        file.puts content
      when Array
        file.puts content.join("\n")
      end
    end

    file_path
  end

  def create_empty_file(file_path)
    create_file(file_path, '')
  end

  def expect_offence(yaml)
    File.open('spec/tmp/original.yml', 'w') do |file|
      file.write yaml
    end

    expect(Yalphabetize::CLI.call(['spec/tmp'])).to eq 1
  end

  def expect_no_offences(yaml)
    File.open('spec/tmp/original.yml', 'w') do |file|
      file.write yaml
    end

    expect(Yalphabetize::CLI.call(['spec/tmp'])).to eq 0
  end

  def expect_reordering(original_yaml, final_yaml)
    File.open('spec/tmp/original.yml', 'w') do |file|
      file.write original_yaml
    end

    Yalphabetize::CLI.call(['spec/tmp', '-a'])

    File.open('spec/tmp/final.yml', 'w') do |file|
      file.write final_yaml
    end

    original = File.read 'spec/tmp/original.yml'
    final = File.read 'spec/tmp/final.yml'

    expect(final).to eq original
  end

  def expect_no_reordering(original_yaml)
    expect_reordering(original_yaml, original_yaml)
  end
end
