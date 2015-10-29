class InfluencerList < ActiveRecord::Base
  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_many :list_memberships, dependent: :destroy
  has_many :profiles, through: :list_memberships
  has_many :organization_list_memberships, dependent: :destroy
  has_many :organizations, through: :organization_list_memberships

  validates :name, presence: true, uniqueness: { scope: :user_id }

  before_create :assign_uuid

  def add_profile(profile)
    if profiles.exclude?(profile)
      profiles << profile
    end
  end

  def add_profiles(new_profiles)
    self.profiles |= new_profiles
  end

  def remove_profile(profile)
    profiles.delete(profile)
  end

  def to_param
    uuid
  end

  def fresh_uuid
    SecureRandom.uuid
  end

  def organization_membership(organization)
    organization_list_memberships.find_by(organization: organization)
  end

  private

  def assign_uuid
    self.uuid = fresh_uuid
  end
end
