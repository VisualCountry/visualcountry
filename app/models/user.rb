class User < ActiveRecord::Base
  attr_reader :focus_tokens

  SOCIAL_PROFILES = %w(vine twitter instagram facebook pinterest)
  FOLLOWER_COUNT_METHODS = SOCIAL_PROFILES.map { |p| "#{p}_follower_count"}

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

   def vine_media
    return unless vine_client

    Rails.cache.fetch("vine-media-#{self.id}", :exprires_in => 3600) do
      vine_client.media.first(9)
    end
  end

  def instagram_media
    return unless instagram_client

    Rails.cache.fetch("instagram-media-#{self.id}", :exprires_in => 3600) do
      instagram_client.user_recent_media.first(9)
    end
  end

  def vine_follower_count
    return unless vine_client

    Rails.cache.fetch("vine-follower-count-#{self.id}", :exprires_in => 3600) do
      vine_client.user.followerCount
    end
  end

  def facebook_follower_count
    return unless facebook_client

    Rails.cache.fetch("facebook-follower-count-#{self.id}", :exprires_in => 3600) do
      facebook_client.get_connections('me', 'friends').raw_response['summary']['total_count']
    end
  end

  def instagram_follower_count
    return unless instagram_client

    Rails.cache.fetch("instagram-follower-count-#{self.id}", :exprires_in => 3600) do
      instagram_client.user['counts']['followed_by']
    end
  end

  def instagram_following_count
    return unless instagram_client

    Rails.cache.fetch("instagram-following-count-#{self.id}", :exprires_in => 3600) do
      instagram_client.user['counts']['follows']
    end
  end

  def twitter_follower_count
    return unless twitter_client

    Rails.cache.fetch("twitter-follower-count-#{self.id}", :exprires_in => 3600) do
      twitter_client.current_user.followers_count
    end
  end

  def pinterest_follower_count
    return unless pinterest_client

    #show_pinterest? ? pinterest_client.user_followed_by : 0
  end

  def total_social_count
    FOLLOWER_COUNT_METHODS.inject(0) do |sum, method|
      count = send(method)
      count == nil ? sum += 0 : sum += count
    end
  end

  private

  def self.nil_if_blank(array)
    array.reject(&:empty?)
  end

  def vine_client
    return unless self.vine_token

    @vine_client ||= Vine.new(self.vine_token)
  end

  def pinterest_client
    return unless self.pinterest_token

    @pinterest_client ||= Pinterest::Base.new(:access_token => self.pinterest_token)
  end

  def twitter_client
    return unless self.twitter_token && self.twitter_token_secret

    @twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY')
      config.consumer_secret     = ENV.fetch('TWITTER_SECRET_KEY')
      config.access_token        = self.twitter_token
      config.access_token_secret = self.twitter_token_secret
    end
  end

  def instagram_client
    return unless self.instagram_token

    @instagram_client ||= Instagram.client(:access_token => self.instagram_token)
  end

  def facebook_client
    return unless self.facebook_token

    @facebook_client ||= Koala::Facebook::API.new(self.facebook_token)
  end
end
