class PortfolioItem < ActiveRecord::Base
  belongs_to :profile
  belongs_to :item, polymorphic: true

  validates :profile_id, :item, presence: true
end
