class VimeoVideo < ActiveRecord::Base
  validates :guid, presence: true
end
