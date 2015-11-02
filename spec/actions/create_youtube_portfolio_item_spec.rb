require 'rails_helper'

RSpec.describe CreateYoutubePortfolioItem do
  let(:profile) { create :profile }
  let(:source) { 'https://www.youtube.com/watch?v=tIdIqbv7SPo' }

  before do
    expect(CreateYoutubeVideo)
      .to receive(:perform)
      .with(source: source)
      .and_call_original
  end

  subject do
    CreateYoutubePortfolioItem.perform(profile: profile, source: source)
  end

  it 'creates a portfolio item' do
    expect { subject }.to change { PortfolioItem.count }.by(1)
  end
end
