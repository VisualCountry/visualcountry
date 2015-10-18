class Organization < ActiveRecord::Base
  has_many :organization_memberships, dependent: :destroy
  has_many :users, through: :organization_memberships #TODO: Remove after profile refactor
  has_many :profiles, through: :organization_memberships
  has_many :organization_list_memberships, dependent: :destroy
  has_many :influencer_lists, through: :organization_list_memberships

  validates :name, presence: true, uniqueness: true

  #TODO: Remove after profile refactor
  def add_user(user)
    if users.exclude?(user)
      users << user
    end
  end

  def add_profile(profile)
    if profiles.exclude?(profile)
      profiles << profile
    end
  end

  def add_list(list)
    if influencer_lists.exclude?(list)
      influencer_lists << list
    end
  end
end
