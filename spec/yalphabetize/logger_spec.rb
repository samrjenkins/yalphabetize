# frozen_string_literal: true

RSpec.describe Yalphabetize::Logger do
  subject { described_class.new($stdout) }

  describe '#initial_summary' do
    subject { super().initial_summary(%w[path1 path2 path3]) }

    it 'logs the number of YAML files being inspected' do
      expect { subject }.to output("Inspecting 3 YAML files\n").to_stdout
    end
  end
end
