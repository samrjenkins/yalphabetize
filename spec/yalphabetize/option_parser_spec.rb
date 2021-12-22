# frozen_string_literal: true

RSpec.describe Yalphabetize::OptionParser do
  describe '.parse!' do
    subject { described_class.parse!(argv) }

    context 'when no options provided' do
      let(:argv) { %w[foo bar baz] }

      it { is_expected.to eq({}) }
    end

    context 'when -h option provided' do
      let(:argv) { ['-h'] }

      expected = <<~STRING
        Usage: yalphabetize [options] [file1, file2, ...]
            -a, --autocorrect                Automatically alphabetize inspected yaml files
            -h, --help                       Prints this help
      STRING

      it do
        expect(Kernel).to receive(:exit)
        expect { subject }.to output(expected).to_stdout
      end
    end

    context 'when --help option provided' do
      let(:argv) { ['--help'] }

      expected = <<~STRING
        Usage: yalphabetize [options] [file1, file2, ...]
            -a, --autocorrect                Automatically alphabetize inspected yaml files
            -h, --help                       Prints this help
      STRING

      it do
        expect(Kernel).to receive(:exit)
        expect { subject }.to output(expected).to_stdout
      end
    end

    context 'when -a option provided' do
      let(:argv) { ['-a'] }

      it { is_expected.to eq({ autocorrect: true }) }
    end

    context 'when --autocorrect option provided' do
      let(:argv) { ['--autocorrect'] }

      it { is_expected.to eq({ autocorrect: true }) }
    end
  end
end
