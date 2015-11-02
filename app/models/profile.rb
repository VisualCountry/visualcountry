class Profile < ActiveRecord::Base
  SOCIAL_PLATFORMS = %w(vine twitter instagram facebook pinterest)

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

  delegate :email, to: :user, allow_nil: true

  validates :bio, length: { maximum: 300 }

  after_save :update_total_follower_count!
  after_validation :normalize_city_name, if: :city_changed?

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
    follower_count_columns = SOCIAL_PLATFORMS.map { |p| "#{p}_follower_count" }
    return unless (changed & follower_count_columns).present?

    changes_applied
    update(total_follower_count: total_follower_count)
  end

  def total_follower_count
    SOCIAL_PLATFORMS.map { |p| send("#{p}_follower_count") }.compact.inject(:+)
  end

  def lists_without(profile)
    user.influencer_lists.select { |list| list.profiles.exclude?(profile) }
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

  #OPTIMIZE: If this turns into an expensive query, it may be worthwhile to
  # rewrite in AREL
  def portfolio
    PortfolioItem.for(self).map(&:item)
  end

  private

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
