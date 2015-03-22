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

  accepts_nested_attributes_for :clients, allow_destroy: true
  accepts_nested_attributes_for :press, allow_destroy: true

  has_attached_file :picture
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  validates :password, length: { in: 6..128 }, on: :update, allow_blank: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :instagram, :twitter, :pinterest]

  delegate :media, to: :instagram, prefix: true, allow_nil: true
  delegate :media, to: :vine, prefix: true, allow_nil: true

  scope :by_name, -> (name) { User.where('"users".name ILIKE ?', "%#{name}%") if name.present? }

  scope :by_interest_ids, -> (ids) do
    joins(:interests).where(interests: {id: nil_if_blank(ids)}) if ids.present?
  end

  scope :by_social_profiles, -> (social_profiles) do
    column_names = social_profiles.map { |profile| "#{profile}_token" }
    query = column_names.map { |column_name| "#{column_name} IS NOT NULL" }.join(' AND ')

    where(query) if query
  end

  def self.search(options = {})
    all.
      by_name(options[:name]).
      by_interest_ids(nil_if_blank(options[:interests])).
      by_social_profiles(nil_if_blank(options[:social_profiles])).
      uniq
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

  private

  def instagram
    @instagram ||= InstagramService.from_user(self)
  end

  def vine
    @vine ||= VineService.from_user(self)
  end

  def twitter
    @twitter ||= TwitterService.from_user(self)
  end

  def facebook
    @facebook ||= FacebookService.from_user(self)
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

  def self.nil_if_blank(array)
    array.reject(&:empty?)
  end
end
