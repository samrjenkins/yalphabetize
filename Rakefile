# frozen_string_literal: true

task default: %w[spec rubocop yalphabetize]

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new

require 'yalphabetize'
task :yalphabetize do
  exit(1) if Yalphabetize::CLI.call(ARGV).nonzero?
end
