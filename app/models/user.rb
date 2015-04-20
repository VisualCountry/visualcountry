class User < ActiveRecord::Base
  attr_reader :focus_tokens

  SOCIAL_PLATFORMS = %w(vine twitter instagram facebook pinterest)
  FOLLOWER_COUNT_METHODS = SOCIAL_PLATFORMS.map { |p| "#{p}_follower_count"}
  FOLLOWER_COUNT_COLUMNS = FOLLOWER_COUNT_METHODS.map { |p| "cached_#{p}"}

  after_save :update_total_follower_count!

  has_and_belongs_to_many :interests
  has_and_belongs_to_many :focuses
  has_and_belongs_to_many :clients

  has_many :press
  has_many :influencer_lists, dependent: :destroy

  accepts_nested_attributes_for :clients, allow_destroy: true
  accepts_nested_attributes_for :press, allow_destroy: true

  has_attached_file :picture, :styles => { :medium => "300x300#", :thumb => "50x50#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  validates :password, length: { in: 6..128 }, on: :update, allow_blank: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable,
         omniauth_providers: [:facebook, :instagram, :twitter, :pinterest]

  delegate :media, to: :instagram, prefix: true, allow_nil: true
  delegate :media, to: :vine, prefix: true, allow_nil: true

  enum gender: {
    "Female" => 0,
    "Male" => 1,
    "Other" => 2,
  }
  enum ethnicity: {
    "Hispanic or Latino" => 0,
    "Native American" => 1,
    "Asian" => 2,
    "Black or African American" => 3,
    "Native Hawaiian or other Pacific Islander" => 4,
    "White" => 5,
    "Other/prefer not to answer" => 6,
}

  geocoded_by :city

  reverse_geocoded_by :latitude, :longitude do |obj, (result, _)|
    if result.present?
      obj.city = "#{result.city}, #{result.state_code}"
    end
  end

  after_validation :normalize_city_name, if: :city_changed?

  def update_total_follower_count!
    return unless (changed & FOLLOWER_COUNT_COLUMNS).present?

    changes_applied
    total_follower_count = follower_counts.inject(:+)
    update(total_follower_count: total_follower_count)
  end

  def warm_follower_count_cache
    !!follower_counts
  end

  def instagram_follower_count
    from_database_or_service(:instagram)
  end

  def vine_follower_count
    from_database_or_service(:vine)
  end

  def twitter_follower_count
    from_database_or_service(:twitter)
  end

  def facebook_follower_count
    from_database_or_service(:facebook)
  end

  def pinterest_follower_count
    #TODO
  end

  def has_account?
    true
  end

  # Devise, I hate you so much.
  def update_without_password(params, *options)
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def lists_without(user)
    influencer_lists.select { |list| list.users.exclude?(user) }
  end

  def membership_in(list)
    ListMembership.find_by(user: self, influencer_list: list)
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

  def instagram
    @instagram ||= InstagramAdapter.from_user(self)
  end

  def vine
    @vine ||= VineAdapter.from_user(self)
  end

  def twitter
    @twitter ||= TwitterAdapter.from_user(self)
  end

  def facebook
    @facebook ||= FacebookAdapter.from_user(self)
  end

  def from_database_or_service(platform)
    follower_count = "cached_#{platform}_follower_count"

    if attribute_present?(follower_count)
      attributes[follower_count]
    else
      return unless send(platform)

      send(platform).follower_count.tap do |count|
        update!(follower_count => count)
      end
    end
  end

  def follower_counts
    FOLLOWER_COUNT_METHODS.map { |p| send(p) }.compact
  end
end
