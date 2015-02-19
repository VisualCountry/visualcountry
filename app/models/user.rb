class User < ActiveRecord::Base
  SOCIAL_PROFILES = %w(vine twitter instagram facebook pinterest)

  FOLLOWER_COUNT_METHODS = SOCIAL_PROFILES.map { |p| "#{p}_follower_count"}

  attr_reader :focus_tokens

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :instagram, :twitter, :pinterest]

  has_and_belongs_to_many :interests
  has_and_belongs_to_many :focuses
  has_and_belongs_to_many :clients

  has_many :press

  accepts_nested_attributes_for :clients, allow_destroy: true
  accepts_nested_attributes_for :press, allow_destroy: true

  has_attached_file :picture
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  validates :password, length: { in: 6..128 }, on: :update, allow_blank: true


  def self.search(options = {})
    set_fuzzy_search_threshold

    # FIXME
    if by_name(options[:name]) && by_interest_ids(options[:interests]) && by_social_profiles(options[:social_profiles])
      by_name(options[:name]) & by_interest_ids(options[:interests]) & by_social_profiles(options[:social_profiles])
    elsif !by_name(options[:name]) && by_interest_ids(options[:interests]) && by_social_profiles(options[:social_profiles])
      by_interest_ids(options[:interests]) & by_social_profiles(options[:social_profiles])
    elsif by_name(options[:name]) && !by_interest_ids(options[:interests]) && by_social_profiles(options[:social_profiles])
      by_name(options[:name]) & by_social_profiles(options[:social_profiles])
    elsif by_name(options[:name]) && by_interest_ids(options[:interests]) && !by_social_profiles(options[:social_profiles])
      by_name(options[:name]) & by_interest_ids(options[:interests])
    elsif by_name(options[:name]) && !by_interest_ids(options[:interests]) && !by_social_profiles(options[:social_profiles])
      by_name(options[:name])
    elsif !by_name(options[:name]) && by_interest_ids(options[:interests]) && !by_social_profiles(options[:social_profiles])
      by_interest_ids(options[:interests])
    elsif !by_name(options[:name]) && !by_interest_ids(options[:interests]) && by_social_profiles(options[:social_profiles])
      by_social_profiles(options[:social_profiles])
    end
  end

  def self.by_name(name)
    return unless name

    all.fuzzy_search(name: name)
  end

  def self.by_interest_ids(interest_ids)
    interest_ids = compact_empty_strings(interest_ids)
    return unless interest_ids

    joined_interest_ids = interest_ids.join('|')
    all.joins(:interests).advanced_search(interests: {id: joined_interest_ids})
  end

  def self.by_social_profiles(social_profiles)
    social_profiles = compact_empty_strings(social_profiles)
    return unless social_profiles

    collection = social_profiles.map do |social|
      all & where.not("#{social}_token" => nil)
    end.flatten.uniq.compact

    collection.select do |user|
      user.vine_email && user.vine_password
    end
  end

  def vine_follower_count
    return unless self.vine_email && self.vine_password

    Rails.cache.fetch("vine-follower-count-#{self.id}", :exprires_in => 3600) do
      vine_client.user_info['followerCount']
    end
  end

  def vine_media
    return unless vine_client

    Rails.cache.fetch("vine-media-#{self.id}", :exprires_in => 3600) do
      vine_client.timelines.records
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

  def instagram_media
    return unless instagram_client

    Rails.cache.fetch("instagram-media-#{self.id}", :exprires_in => 3600) do
      instagram_client.user_recent_media
    end
    #    instagram_client.user_recent_media.first['images']['standard_resolution']['url']
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

  def self.set_fuzzy_search_threshold
    ActiveRecord::Base.connection.execute('SELECT set_limit(0.1);')
  end

  def self.compact_empty_strings(array)
    array.reject! { |element| element == '' }
    return unless array.present?
  end

  def vine_client
    return unless self.vine_email && self.vine_password

    @vine_client ||= Vine::Client.new(self.vine_email, self.vine_password)
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
