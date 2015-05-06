class Album < ActiveRecord::Base
  attr_accessible :title
  has_many :photo
end
