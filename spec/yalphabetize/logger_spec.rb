# frozen_string_literal: true

RSpec.describe Yalphabetize::Logger do
  let(:logger) { described_class.new($stdout) }

  describe '#initial_summary' do
    subject { logger.initial_summary(%w[path1 path2 path3]) }

    it 'logs the number of YAML files being inspected' do
      expect { subject }.to output("Inspecting 3 YAML files\n").to_stdout
    end
  end

  describe '#final_summary' do
    subject { logger.final_summary(inspected_count, result) }

    let(:inspected_count) { 123 }

    context 'when no offences have been detected' do
      let(:result) { [] }

      it 'logs the expected output' do
        expect { subject }.to output("\nInspected: 123\n\e[32mOffences: 0\e[0m\n").to_stdout
      end
    end

    context 'when an offence has been detected' do
      let(:result) { [['dummy_path', :detected]] }

      let(:expected_output) do
        <<~STR

          Inspected: 123
          \e[31mOffences: 1\e[0m
          \e[33mdummy_path\e[0m
          Offences can be automatically fixed with `-a` or `--autocorrect`
        STR
      end

      it 'logs the expected output' do
        expect { subject }.to output(expected_output).to_stdout
      end
    end
  end
end
