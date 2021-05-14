# frozen_string_literal: true

require './lib/yalphabetize/reader'

RSpec.describe Yalphabetize::Reader do
  let(:file_path) { 'spec/tmp/mock.yml' }
  let(:file_content) { '' }

  before do
    File.open(file_path, 'w') do |file|
      file.write(file_content)
    end
  end

  describe '#to_ast' do
    subject { Yalphabetize::Reader.new(file_path).to_ast }

    it { is_expected.to be_a Psych::Nodes::Stream }

    it 'opens and parses the file' do
      expect(File).to receive(:read).with(file_path).and_return('the_file')
      expect(Psych).to receive(:parse_stream).with('the_file').and_return(Psych::Nodes::Stream.new)

      subject
    end

    it 'pairs up the children of a mapping node' do
      mapping = Psych::Nodes::Mapping.new
      child0 = Psych::Nodes::Scalar.new(0)
      child1 = Psych::Nodes::Scalar.new(1)
      child2 = Psych::Nodes::Scalar.new(2)
      child3 = Psych::Nodes::Scalar.new(3)

      mapping.children.push(child0, child1, child2, child3)

      allow(Psych).to receive(:parse_stream).and_return(mapping)

      expect(subject.children).to eq(
        [
          [child0, child1],
          [child2, child3]
        ]
      )
    end

    context 'when yaml contains invalid syntax' do
      let(:file_content) do
        <<~YAML
          Apples: {{ 1 }} apples {{ 2 }}
        YAML
      end

      it do
        expect { subject }
          .to raise_error(
            Yalphabetize::ParsingError,
            "(#{file_path}): did not find expected key while parsing a block mapping at line 1 column 1"
          )
      end
    end
  end
end
