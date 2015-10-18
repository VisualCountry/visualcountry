class Profile < ActiveRecord::Base
  attr_reader :focus_tokens

  belongs_to :user

  has_and_belongs_to_many :interests
  has_and_belongs_to_many :focuses
  has_and_belongs_to_many :clients

  has_many :press, dependent: :destroy
  has_many :list_memberships, dependent: :destroy
  has_many :organization_memberships, dependent: :destroy
  has_many :organizations, through: :organization_memberships

  accepts_nested_attributes_for :clients, allow_destroy: true
  accepts_nested_attributes_for :press, allow_destroy: true

  enum gender: {
    'Female'  => 0,
    'Male'    => 1,
    'Other'   => 2,
  }

  enum ethnicity: {
    'Hispanic or Latino'                        => 0,
    'Native American'                           => 1,
    'Asian'                                     => 2,
    'Black or African American'                 => 3,
    'Native Hawaiian or other Pacific Islander' => 4,
    'White'                                     => 5,
    'Other/prefer not to answer'                => 6,
  }

  delegate :email, to: :user

  validates :bio, length: { maximum: 300 }

  has_attached_file :picture,
    default_url: 'missing.png',
    styles: {
      medium: '300x300#',
      thumb: '50x50#'
    }
  crop_attached_file :picture
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

  def self.total_reach
    sum(:total_follower_count)
  end

  def lists_without(profile)
    influencer_lists.select { |list| list.profiles.exclude?(profile) }
  end

  def list_membership_in(list)
    list_memberships.find_by(influencer_list: list)
  end

  def lists_member_of
    list_memberships.map(&:influencer_list).compact
  end

  def organization_membership_in(organization)
    organization_memberships.find_by(organization: organization)
  end
end
