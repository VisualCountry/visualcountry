class Album < ActiveRecord::Base
  has_many :photo
end
