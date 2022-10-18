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
    subject { logger.final_summary }

    context 'when no offences have been detected' do
      it 'logs the expected output' do
        expect { subject }.to output("\nInspected: 0\n\e[32mOffences: 0\e[0m\n").to_stdout
      end
    end

    context 'when an offence has been detected' do
      subject do
        logger.log_offence('dummy_path')
        logger.final_summary
      end

      let(:expected_output) do
        <<~STR
          \e[31mO\e[0m
          Inspected: 1
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
