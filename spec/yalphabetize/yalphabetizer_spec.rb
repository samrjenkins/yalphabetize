# frozen_string_literal: true

RSpec.describe Yalphabetize::Yalphabetizer do
  describe '.call' do
    subject { described_class.call(args, opts) }

    let(:args) { [] }
    let(:opts) { {} }

    context 'without config' do
      it 'calls YamlFinder with only and exclude empty' do
        expect(Yalphabetize::YamlFinder).to receive(:paths).with(only: [], exclude: []).and_return []
        subject
      end
    end

    context 'with only config' do
      include_context 'with configuration', 'only' => ['foo']

      it 'calls YamlFinder with exclude empty and only with value from config' do
        expect(Yalphabetize::YamlFinder).to receive(:paths).with(only: ['foo'], exclude: []).and_return []
        subject
      end

      context 'when file paths provided as args' do
        let(:args) { ['bar'] }

        it 'calls YamlFinder with only value from args' do
          expect(Yalphabetize::YamlFinder).to receive(:paths).with(only: ['bar'], exclude: []).and_return []
          subject
        end
      end
    end

    context 'with excluded config' do
      include_context 'with configuration', 'exclude' => ['baz']

      it 'calls YamlFinder with only empty and exclude with value from config' do
        expect(Yalphabetize::YamlFinder).to receive(:paths).with(only: [], exclude: ['baz']).and_return []
        subject
      end
    end

    describe 'stdout' do
      let(:args) { ['spec/tmp'] }

      context 'when inspecting 0 files' do
        it 'outputs 0 file message to stdout', :enable_logging do
          expect { subject }.to output(<<~STDOUT).to_stdout
            Inspecting 0 YAML files

            Inspected: 0
            \e[32mOffences: 0\e[0m
          STDOUT
        end
      end

      context 'when inspecting 1 empty file' do
        before { create_empty_file('1.yml') }

        it 'outputs 1 file message to stdout', :enable_logging do
          expect { subject }.to output(<<~STDOUT).to_stdout
            Inspecting 1 YAML files
            \e[32m.\e[0m
            Inspected: 1
            \e[32mOffences: 0\e[0m
          STDOUT
        end
      end

      context 'when inspecting 2 empty files' do
        before do
          create_empty_file('1.yml')
          create_empty_file('2.yml')
        end

        it 'outputs 2 file message to stdout', :enable_logging do
          expect { subject }.to output(<<~STDOUT).to_stdout
            Inspecting 2 YAML files
            \e[32m.\e[0m\e[32m.\e[0m
            Inspected: 2
            \e[32mOffences: 0\e[0m
          STDOUT
        end
      end

      context 'when inspecting 1 offending file without autocorrect' do
        let(:unordered_yaml) do
          <<~YAML
            bananas: 2
            apples: 1
          YAML
        end

        before { create_file('1.yml', unordered_yaml) }

        it 'outputs 1 offence message to stdout', :enable_logging do
          expect { subject }.to output(<<~STDOUT).to_stdout
            Inspecting 1 YAML files
            \e[31mO\e[0m
            Inspected: 1
            \e[31mOffences: 1\e[0m
            \e[33mspec/tmp/1.yml\e[0m
            Offences can be automatically fixed with `-a` or `--autocorrect`
          STDOUT
        end
      end

      context 'when inspecting 1 offending file and 1 empty file without autocorrect' do
        let(:unordered_yaml) do
          <<~YAML
            bananas: 2
            apples: 1
          YAML
        end

        before do
          create_empty_file('1.yml')
          create_file('2.yml', unordered_yaml)
        end

        it 'outputs 1 offence message to stdout', :enable_logging do
          expect { subject }.to output(<<~STDOUT).to_stdout
            Inspecting 2 YAML files
            \e[32m.\e[0m\e[31mO\e[0m
            Inspected: 2
            \e[31mOffences: 1\e[0m
            \e[33mspec/tmp/2.yml\e[0m
            Offences can be automatically fixed with `-a` or `--autocorrect`
          STDOUT
        end
      end

      context 'when inspecting 1 offending file with autocorrect' do
        let(:opts) { { autocorrect: true } }
        let(:unordered_yaml) do
          <<~YAML
            bananas: 2
            apples: 1
          YAML
        end

        before { create_file('1.yml', unordered_yaml) }

        it 'outputs 1 offence message to stdout', :enable_logging do
          expect { subject }.to output(<<~STDOUT).to_stdout
            Inspecting 1 YAML files
            \e[31mO\e[0m
            Inspected: 1
            \e[31mOffences: 1\e[0m
            \e[33mspec/tmp/1.yml\e[0m \e[32mCORRECTED\e[0m
          STDOUT
        end
      end

      context 'when inspecting 1 offending file and 1 empty file with autocorrect' do
        let(:opts) { { autocorrect: true } }
        let(:unordered_yaml) do
          <<~YAML
            bananas: 2
            apples: 1
          YAML
        end

        before do
          create_empty_file('1.yml')
          create_file('2.yml', unordered_yaml)
        end

        it 'outputs 1 offence message to stdout', :enable_logging do
          expect { subject }.to output(<<~STDOUT).to_stdout
            Inspecting 2 YAML files
            \e[32m.\e[0m\e[31mO\e[0m
            Inspected: 2
            \e[31mOffences: 1\e[0m
            \e[33mspec/tmp/2.yml\e[0m \e[32mCORRECTED\e[0m
          STDOUT
        end
      end

      context 'when inspecting multiple offending files and multiple empty files without autocorrect' do
        let(:unordered_yaml) do
          <<~YAML
            bananas: 2
            apples: 1
          YAML
        end

        before do
          [1, 2, 5, 6, 8].each { |i| create_empty_file("#{i}.yml") }
          [3, 4, 7].each { |i| create_file("#{i}.yml", unordered_yaml) }
        end

        it 'outputs 1 offence message to stdout', :enable_logging do
          expect { subject }.to output(<<~STDOUT).to_stdout
            Inspecting 8 YAML files
            \e[32m.\e[0m\e[32m.\e[0m\e[31mO\e[0m\e[31mO\e[0m\e[32m.\e[0m\e[32m.\e[0m\e[31mO\e[0m\e[32m.\e[0m
            Inspected: 8
            \e[31mOffences: 3\e[0m
            \e[33mspec/tmp/3.yml\e[0m
            \e[33mspec/tmp/4.yml\e[0m
            \e[33mspec/tmp/7.yml\e[0m
            Offences can be automatically fixed with `-a` or `--autocorrect`
          STDOUT
        end
      end

      context 'when inspecting multiple offending files and multiple empty files with autocorrect' do
        let(:opts) { { autocorrect: true } }
        let(:unordered_yaml) do
          <<~YAML
            bananas: 2
            apples: 1
          YAML
        end

        before do
          [1, 2, 5, 6, 8].each { |i| create_empty_file("#{i}.yml") }
          [3, 4, 7].each { |i| create_file("#{i}.yml", unordered_yaml) }
        end

        it 'outputs 1 offence message to stdout', :enable_logging do
          expect { subject }.to output(<<~STDOUT).to_stdout
            Inspecting 8 YAML files
            \e[32m.\e[0m\e[32m.\e[0m\e[31mO\e[0m\e[31mO\e[0m\e[32m.\e[0m\e[32m.\e[0m\e[31mO\e[0m\e[32m.\e[0m
            Inspected: 8
            \e[31mOffences: 3\e[0m
            \e[33mspec/tmp/3.yml\e[0m \e[32mCORRECTED\e[0m
            \e[33mspec/tmp/4.yml\e[0m \e[32mCORRECTED\e[0m
            \e[33mspec/tmp/7.yml\e[0m \e[32mCORRECTED\e[0m
          STDOUT
        end
      end
    end
  end
end
