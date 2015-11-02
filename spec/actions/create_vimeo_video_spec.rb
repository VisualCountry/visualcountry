require 'rails_helper'

RSpec.describe CreateVimeoVideo do
  let(:guid) { '122291819' }
  let(:source) { "https://vimeo.com/#{guid}" }

  subject { CreateVimeoVideo.perform(source: source) }

  it 'sets the guid' do
    expect(subject.guid).to eq guid
  end

  it 'creates a youtube video' do
    expect { subject }.to change { VimeoVideo.count }.by(1)
  end
end
