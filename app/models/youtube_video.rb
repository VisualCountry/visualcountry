class YoutubeVideo < ActiveRecord::Base
  validates :guid, presence: true

  def embed_url
    "http://www.youtube.com/embed/#{guid}?showinfo=0&controls=0"
  end
end
