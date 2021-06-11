# frozen_string_literal: true

require './lib/yalphabetize/yaml_finder'

RSpec.describe Yalphabetize::YamlFinder do
  include FileHelper

  describe '#paths' do
    subject { Yalphabetize::YamlFinder.new.paths(arg) }

    before do
      create_empty_file('yml_in_top_dir.yml')
      create_empty_file('yaml_in_top_dir.yaml')
      create_empty_file('sub_dir/yml_in_sub_dir.yml')
      create_empty_file('sub_dir/yaml_in_sub_dir.yaml')

      create_empty_file('rb_in_top_dir.rb')
    end

    context 'when argument is empty' do
      let(:arg) { [] }

      it 'lists all yaml files in working directory' do
        Dir.chdir('spec/tmp') do
          is_expected.to match_array(
            [
              File.expand_path('yml_in_top_dir.yml'),
              File.expand_path('yaml_in_top_dir.yaml'),
              File.expand_path('sub_dir/yml_in_sub_dir.yml'),
              File.expand_path('sub_dir/yaml_in_sub_dir.yaml')
            ]
          )
        end
      end
    end

    context 'when argument is an existing directory' do
      let(:arg) { ['spec/tmp/sub_dir'] }

      it 'lists all yaml files in specified directory' do
        is_expected.to match_array(
          [
            File.expand_path('spec/tmp/sub_dir/yml_in_sub_dir.yml'),
            File.expand_path('spec/tmp/sub_dir/yaml_in_sub_dir.yaml')
          ]
        )
      end
    end

    context 'when argument is an existing yaml file' do
      let(:arg) { ['spec/tmp/sub_dir/yml_in_sub_dir.yml'] }

      it 'lists only the specified file' do
        is_expected.to match_array [File.expand_path('spec/tmp/sub_dir/yml_in_sub_dir.yml')]
      end
    end

    context 'when argument is an existing non-yaml file' do
      let(:arg) { ['spec/tmp/rb_in_top_dir.rb'] }

      it 'lists nothing' do
        is_expected.to match_array []
      end
    end

    context 'when given multiple arguments' do
      let(:arg) { ['spec/tmp/sub_dir', 'spec/tmp/yml_in_top_dir.yml'] }

      it 'lists all specified yaml files and yaml files in specified directories' do
        is_expected.to match_array(
          [
            File.expand_path('spec/tmp/yml_in_top_dir.yml'),
            File.expand_path('spec/tmp/sub_dir/yml_in_sub_dir.yml'),
            File.expand_path('spec/tmp/sub_dir/yaml_in_sub_dir.yaml')
          ]
        )
      end
    end

    context 'when given file that does not exist' do
      let(:arg) { ['file_that_does_not_exist.yml'] }

      it 'lists nothing' do
        is_expected.to match_array []
      end
    end

    context 'when given directory that does not exist' do
      let(:arg) { ['spec/tmp/directory_that_does_not_exist'] }

      it 'lists nothing' do
        is_expected.to match_array []
      end
    end
  end
end
