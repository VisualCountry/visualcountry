class YoutubeVideo < ActiveRecord::Base
  validates :guid, presence: true
end
