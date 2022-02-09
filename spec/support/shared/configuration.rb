# frozen_string_literal: true

RSpec.shared_context 'with configuration' do |config|
  before do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('.yalphabetize.yml').and_return(true)
    allow(Psych).to receive(:load_file).and_call_original
    allow(Psych).to receive(:load_file).with('.yalphabetize.yml').and_return(config)
  end
end
