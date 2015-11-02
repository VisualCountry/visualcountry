require 'rails_helper'

RSpec.describe CreateVimeoPortfolioItem do
  let(:profile) { create :profile }
  let(:source) { 'https://vimeo.com/122291819' }

  before do
    expect(CreateVimeoVideo)
      .to receive(:perform)
      .with(source: source)
      .and_call_original
  end

  subject do
    CreateVimeoPortfolioItem.perform(profile: profile, source: source)
  end

  it 'creates a portfolio item' do
    expect { subject }.to change { PortfolioItem.count }.by(1)
  end
end
