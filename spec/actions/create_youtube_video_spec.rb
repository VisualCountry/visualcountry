require 'rails_helper'

RSpec.describe CreateYoutubeVideo do
  let(:guid) { 'O0RU_Nyr4l4' }
  let(:source) { "https://www.youtube.com/watch?v=#{guid}" }

  subject { CreateYoutubeVideo.perform(source: source) }

  it 'sets the guid' do
    expect(subject.guid).to eq guid
  end

  context 'clean desktop link' do
    it 'creates a youtube video' do
      expect { subject }.to change { YoutubeVideo.count }.by(1)
    end
  end

  context 'desktop link with lots of query params' do
    let(:source) { "https://www.youtube.com/watch?index=12&v=#{guid}&list=LLq9aDxj7rn4ZEWp9rxcEAnw" }

    it 'creates a youtube video' do
      expect { subject }.to change { YoutubeVideo.count }.by(1)
    end
  end

  context 'mobile link' do
    let(:source) { "http://youtu.be/#{guid}" }

    it 'creates a youtube video' do
      expect { subject }.to change { YoutubeVideo.count }.by(1)
    end
  end
end
