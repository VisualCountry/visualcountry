class User < ActiveRecord::Base
  attr_reader :focus_tokens

  SOCIAL_PLATFORMS = %w(vine twitter instagram facebook pinterest)
  FOLLOWER_COUNT_METHODS = SOCIAL_PLATFORMS.map { |p| "#{p}_follower_count"}
  FOLLOWER_COUNT_COLUMNS = FOLLOWER_COUNT_METHODS.map { |p| "cached_#{p}"}

  before_save :set_username
  after_save :update_total_follower_count!

  has_and_belongs_to_many :interests
  has_and_belongs_to_many :focuses
  has_and_belongs_to_many :clients

  has_many :press

  accepts_nested_attributes_for :clients, allow_destroy: true
  accepts_nested_attributes_for :press, allow_destroy: true

  has_attached_file :picture, :styles => { :medium => "300x300#", :thumb => "50x50#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  validates :password, length: { in: 6..128 }, on: :update, allow_blank: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :instagram, :twitter, :pinterest]

  delegate :media, to: :instagram, prefix: true, allow_nil: true
  delegate :media, to: :vine, prefix: true, allow_nil: true

  enum gender: [:female, :male, :other]

  scope :by_name, -> (name) { User.where('"users".name ILIKE ?', "%#{name}%") if name.present? }

  scope :by_interest_ids, -> (ids) do
    joins(:interests).where(interests: {id: nil_if_blank(ids)}) if ids.present?
  end

  scope :by_focus_ids, -> (ids) do
    includes(:focuses).joins(:focuses).where(focuses: {id: nil_if_blank(ids)}) if ids.present?
  end

  scope :by_social_profiles, -> (social_profiles) do
    column_names = social_profiles.map { |profile| "#{profile}_token" }
    query = column_names.map { |column_name| "#{column_name} IS NOT NULL" }.join(' AND ')

    where(query) if query
  end

  # TODO: Abstract to query object
  scope :by_follower_count, -> (min_followers, max_followers, social_profiles) do
    return if min_followers.empty? && max_followers.empty?

    min_followers = (min_followers.empty? ? min_followers = 0 : min_followers.to_i)
    max_followers = (max_followers.empty? ? max_followers =  Float::INFINITY : max_followers.to_i)

    if nil_if_blank(social_profiles).empty?
      where(total_follower_count: min_followers..max_followers)
    else
      follower_count_columns_for_sql = nil_if_blank(social_profiles).map { |p| "cached_#{p}_follower_count" }.join(' + ')
      users = User.find_by_sql("SELECT *, (#{follower_count_columns_for_sql}) sum FROM users;")
      matched_users = users.reject { |user| !user.sum.present? }
      matched_users.select { |result| result.sum > min_followers && result.sum < max_followers }
    end
  end

  def self.search(options = {})
    all.
      by_name(options[:name]).
      by_interest_ids(nil_if_blank(options[:interests])).
      by_focus_ids(nil_if_blank(options[:focuses])).
      by_social_profiles(nil_if_blank(options[:social_profiles])).
      by_follower_count(options[:min_followers], options[:max_followers], options[:social_profiles]).
      uniq
  end

  def set_username
    return unless username.blank?

    update(username: "#{name}.#{DateTime.now.to_i}")
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

  # Devise, I hate you so much.
  def update_without_password(params, *options)
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  private

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

  def self.nil_if_blank(array)
    array.reject(&:empty?)
  end
end
