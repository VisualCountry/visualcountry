class Profile < ActiveRecord::Base
  attr_reader :focus_tokens

  FOLLOWER_COUNT_METHODS = User::SOCIAL_PLATFORMS.map { |p| "#{p}_follower_count"}
  FOLLOWER_COUNT_COLUMNS = FOLLOWER_COUNT_METHODS.map { |p| "cached_#{p}"}

  has_one :user

  has_and_belongs_to_many :interests
  has_and_belongs_to_many :focuses
  has_and_belongs_to_many :clients

  has_many :press, dependent: :destroy
  has_many :influencer_lists, dependent: :destroy
  has_many :list_memberships, dependent: :destroy
  has_many :organization_memberships, dependent: :destroy
  has_many :organizations, through: :organization_memberships

  accepts_nested_attributes_for :clients, allow_destroy: true
  accepts_nested_attributes_for :press, allow_destroy: true

  validates :bio, length: { maximum: 300 }

  after_validation :normalize_city_name, if: :city_changed?
  after_save :update_total_follower_count!

  delegate :email, :admin?, to: :user, allow_nil: true
  delegate :instagram_account, :vine_account, to: :user

  enum gender: {
    'Female' => 0,
    'Male' => 1,
    'Other' => 2,
  }

  enum ethnicity: {
    'Hispanic or Latino' => 0,
    'Native American' => 1,
    'Asian' => 2,
    'Black or African American' => 3,
    'Native Hawaiian or other Pacific Islander' => 4,
    'White' => 5,
    'Other/prefer not to answer' => 6,
  }

  has_attached_file :picture,
    default_url: 'missing.png',
    styles: {
      medium: '300x300#',
      thumb: '50x50#'
    }
  crop_attached_file :picture
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

  geocoded_by :city
  reverse_geocoded_by :latitude, :longitude do |obj, (result, _)|
    if result.present?
      obj.city = "#{result.city}, #{result.state_code}"
    end
  end

  def self.total_reach
    sum(:total_follower_count)
  end

  def update_total_follower_count!
    return unless (changed & FOLLOWER_COUNT_COLUMNS).present?

    changes_applied
    total_follower_count = follower_counts.inject(:+)
    update(total_follower_count: total_follower_count)
  end

  def warm_follower_count_cache
    !!follower_counts
  end

  def instagram_media
    instagram_account.media
  end

  def vine_media
    vine_account.media
  end

  def lists_without(profile)
    influencer_lists.select { |list| list.profiles.exclude?(profile) }
  end

  def list_membership_in(list)
    list_memberships.find_by(influencer_list: list)
  end

  def organization_membership_in(organization)
    organization_memberships.find_by(organization: organization)
  end

  def owns_list?(list)
    list.owner == self
  end

  def lists_member_of
    list_memberships.map(&:influencer_list).compact
  end

  def can_manage_list?(list)
    return true if admin?
    return true if list.owner == self

    list.organizations.where(id: organization_ids).any?
  end

  private

  def follower_counts
    FOLLOWER_COUNT_METHODS.map { |p| send(p) }.compact
  end

  def normalize_city_name
    find_coordinates_from_city_name
    find_canonical_city_name_from_coordinates
  end

  def find_coordinates_from_city_name
    self.latitude, self.longitude = Rails.cache.fetch([:geocode, city]) do
      geocode
      [latitude, longitude]
    end
  end

  def find_canonical_city_name_from_coordinates
    self.city = Rails.cache.fetch([:reverse_geocode, latitude, longitude]) do
      reverse_geocode
      city
    end
  end
end
