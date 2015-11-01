class Client < ActiveRecord::Base
  has_and_belongs_to_many :profiles

  validates :name, presence: true
end
