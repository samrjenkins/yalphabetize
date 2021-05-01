require './lib/yalphabetizer'

RSpec.describe Yalphabetize::Reader do
  describe "#to_ast" do
    subject { described_class.new(file_path).to_ast }

    context "shallow yml" do
      let(:file_path) { 'spec/fixtures/shallow_test.yml' }

      it do
        binding.pry
      end
    end
  end
end

