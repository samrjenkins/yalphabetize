# frozen_string_literal: true

RSpec.describe Yalphabetize::YamlFinder do
  describe '.paths' do
    subject { described_class.paths(only: only, exclude: exclude) }

    before do
      create_empty_file('yml_in_top_dir.yml')
      create_empty_file('yaml_in_top_dir.yaml')
      create_empty_file('sub_dir/yml_in_sub_dir.yml')
      create_empty_file('sub_dir/yaml_in_sub_dir.yaml')

      create_empty_file('rb_in_top_dir.rb')
    end

    let(:exclude) { [] }

    context 'when argument is empty' do
      let(:only) { [] }

      context 'when exclude is empty' do
        let(:exclude) { [] }

        it 'lists all yaml files in working directory' do
          Dir.chdir('spec/tmp') do
            expect(subject).to match_array(
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

      context 'when exclude is an existing directory' do
        let(:exclude) { ['sub_dir'] }

        it 'lists all yaml files in working directory except those in excluded directory' do
          Dir.chdir('spec/tmp') do
            expect(subject).to match_array(
              [
                File.expand_path('yml_in_top_dir.yml'),
                File.expand_path('yaml_in_top_dir.yaml')
              ]
            )
          end
        end
      end

      context 'when exclude is an existing yaml file' do
        let(:exclude) { ['sub_dir/yml_in_sub_dir.yml'] }

        it 'lists all yaml files in working directory excluding the one file' do
          Dir.chdir('spec/tmp') do
            expect(subject).to match_array(
              [
                File.expand_path('yml_in_top_dir.yml'),
                File.expand_path('yaml_in_top_dir.yaml'),
                File.expand_path('sub_dir/yaml_in_sub_dir.yaml')
              ]
            )
          end
        end
      end

      context 'when exclude is an existing non-yaml file' do
        let(:exclude) { ['rb_in_top_dir.rb'] }

        it 'lists all yaml files in working directory' do
          Dir.chdir('spec/tmp') do
            expect(subject).to match_array(
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

      context 'when exclude is a glob' do
        let(:exclude) { ['**/*.yml'] }

        it 'lists all yaml files in working directory excluding those matching the glob' do
          Dir.chdir('spec/tmp') do
            expect(subject).to match_array(
              [
                File.expand_path('yaml_in_top_dir.yaml'),
                File.expand_path('sub_dir/yaml_in_sub_dir.yaml')
              ]
            )
          end
        end
      end

      context 'when exclude is a directory which does not exist' do
        let(:exclude) { ['spec/tmp/directory_that_does_not_exist'] }

        it 'lists all yaml files in working directory' do
          Dir.chdir('spec/tmp') do
            expect(subject).to match_array(
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

      context 'when exclude is a file which does not exist' do
        let(:exclude) { ['file_that_does_not_exist.yml'] }

        it 'lists all yaml files in working directory' do
          Dir.chdir('spec/tmp') do
            expect(subject).to match_array(
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

      context 'when exclude contains multiple paths' do
        let(:exclude) { ['yml_in_top_dir.yml', 'yaml_in_top_dir.yaml'] }

        it 'lists all yaml files in working directory' do
          Dir.chdir('spec/tmp') do
            expect(subject).to match_array(
              [
                File.expand_path('sub_dir/yml_in_sub_dir.yml'),
                File.expand_path('sub_dir/yaml_in_sub_dir.yaml')
              ]
            )
          end
        end
      end
    end

    context 'when argument is an existing directory' do
      let(:only) { ['spec/tmp/sub_dir'] }

      it 'lists all yaml files in specified directory' do
        expect(subject).to match_array(
          [
            File.expand_path('spec/tmp/sub_dir/yml_in_sub_dir.yml'),
            File.expand_path('spec/tmp/sub_dir/yaml_in_sub_dir.yaml')
          ]
        )
      end

      context 'when exclude is an existing yaml file' do
        let(:exclude) { ['spec/tmp/sub_dir/yml_in_sub_dir.yml'] }

        it 'lists all yaml files in specified directory excluding the specified file' do
          expect(subject).to match_array [File.expand_path('spec/tmp/sub_dir/yaml_in_sub_dir.yaml')]
        end
      end
    end

    context 'when argument is an existing yaml file' do
      let(:only) { ['spec/tmp/sub_dir/yml_in_sub_dir.yml'] }

      it 'lists only the specified file' do
        expect(subject).to match_array [File.expand_path('spec/tmp/sub_dir/yml_in_sub_dir.yml')]
      end
    end

    context 'when argument is an existing non-yaml file' do
      let(:only) { ['spec/tmp/rb_in_top_dir.rb'] }

      it 'lists nothing' do
        expect(subject).to match_array []
      end
    end

    context 'when given multiple arguments' do
      let(:only) { ['spec/tmp/sub_dir', 'spec/tmp/yml_in_top_dir.yml'] }

      it 'lists all specified yaml files and yaml files in specified directories' do
        expect(subject).to match_array(
          [
            File.expand_path('spec/tmp/yml_in_top_dir.yml'),
            File.expand_path('spec/tmp/sub_dir/yml_in_sub_dir.yml'),
            File.expand_path('spec/tmp/sub_dir/yaml_in_sub_dir.yaml')
          ]
        )
      end
    end

    context 'when given a glob' do
      let(:only) { ['spec/tmp/**/*.yml'] }

      it 'lists all matching files' do
        expect(subject).to match_array(
          [
            File.expand_path('spec/tmp/yml_in_top_dir.yml'),
            File.expand_path('spec/tmp/sub_dir/yml_in_sub_dir.yml')
          ]
        )
      end
    end

    context 'when given file that does not exist' do
      let(:only) { ['file_that_does_not_exist.yml'] }

      it 'lists nothing' do
        expect(subject).to match_array []
      end
    end

    context 'when given directory that does not exist' do
      let(:only) { ['spec/tmp/directory_that_does_not_exist'] }

      it 'lists nothing' do
        expect(subject).to match_array []
      end
    end
  end
end
