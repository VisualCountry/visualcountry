class PortfolioItem < ActiveRecord::Base
  belongs_to :profile
  belongs_to :item, polymorphic: true

  validates :profile_id, :item, presence: true

  def self.for(profile)
    includes(:item).where(profile: profile)
  end
end
