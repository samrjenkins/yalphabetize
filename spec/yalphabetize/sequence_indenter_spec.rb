# frozen_string_literal: true

RSpec.describe Yalphabetize::SequenceIndenter do
  describe '.call' do
    subject { described_class.call(yaml) }

    context 'when sequence is not nested' do
      let(:yaml) do
        <<~YAML
          - Apples
          - Bananas
        YAML
      end

      it 'does not change indentation of sequence' do
        expect(subject).to eq yaml
      end
    end

    context 'when nesting sequences within sequences' do
      let(:yaml) do
        <<~YAML
          -
            -
              - Apples
              - Bananas
            - Clementines
            - Dates
        YAML
      end

      it 'does not change indentation of sequences' do
        expect(subject).to eq yaml
      end
    end

    context 'when sequence is nested inside mapping' do
      let(:yaml) do
        <<~YAML
          Fruit:
          - Apples
          - Bananas
        YAML
      end

      it 'indents the sequence' do
        expect(subject).to eq(<<~YAML)
          Fruit:
            - Apples
            - Bananas
        YAML
      end
    end

    context 'when two mappings each have a nested sequence' do
      let(:yaml) do
        <<~YAML
          Fruit:
          - Apples
          - Bananas
          Vegetables:
          - Aubergines
          - Beetroot
        YAML
      end

      it 'indents both sequences' do
        expect(subject).to eq(<<~YAML)
          Fruit:
            - Apples
            - Bananas
          Vegetables:
            - Aubergines
            - Beetroot
        YAML
      end
    end

    context 'when sequences are nested inside a mapping at different depths' do
      let(:yaml) do
        <<~YAML
          Fruit:
          - Others:
            - Clementines
            - Dates
          - Apples
          - Bananas
        YAML
      end

      it 'indents the sequence' do
        expect(subject).to eq(<<~YAML)
          Fruit:
            - Others:
                - Clementines
                - Dates
            - Apples
            - Bananas
        YAML
      end
    end

    context 'when sequence contains multi-line string' do
      let(:yaml) do
        <<~YAML
          Fruit:
          - |
            Apples
            more apples
          - Bananas
        YAML
      end

      it 'indents the sequence' do
        expect(subject).to eq(<<~YAML)
          Fruit:
            - |
              Apples
              more apples
            - Bananas
        YAML
      end
    end

    context 'when sequence is flow style' do
      let(:yaml) do
        <<~YAML
          Fruit: [Apples]
        YAML
      end

      it 'does not change the indentation' do
        expect(subject).to eq yaml
      end
    end
  end
end
