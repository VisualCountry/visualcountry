class VimeoVideo < ActiveRecord::Base
  validates :guid, presence: true

  def embed_url
    "http://player.vimeo.com/video/#{guid}?portrait=0&byline=0&title=0"
  end
end
