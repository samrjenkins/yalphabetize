# frozen_string_literal: true

RSpec.describe Yalphabetize::Version do
  describe '::STRING' do
    subject { Yalphabetize::Version::STRING }

    it { is_expected.to match(/\d+\.\d+\.\d+/) }
  end
end
