class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :instagram, :twitter, :pinterest]

  has_attached_file :picture
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  validates :password, length: { in: 6..128 }, on: :update, allow_blank: true

  has_and_belongs_to_many :interests

  has_many :presses
  accepts_nested_attributes_for :presses

  has_many :clients
  accepts_nested_attributes_for :clients

  def vine_follower_count
    Rails.cache.fetch("vine-follower-count-#{self.id}", :exprires_in => 3600) do
      show_vine? ? vine_client.user_info['followerCount'] : 0
    end
  rescue
    'Incorrect credentials'
  end

  def vine_media
    Rails.cache.fetch("vine-media-#{self.id}", :exprires_in => 3600) do
      show_vine? ? vine_client.timelines.records : []
    end
  end

  def facebook_follower_count
    Rails.cache.fetch("facebook-follower-count-#{self.id}", :exprires_in => 3600) do
      show_facebook? ? facebook_client.get_connections('me', 'friends').raw_response['summary']['total_count'] : 0
    end
  end

  def instagram_follower_count
    Rails.cache.fetch("instagram-follower-count-#{self.id}", :exprires_in => 3600) do
      show_instagram? ? instagram_client.user['counts']['followed_by'] : 0
    end
  end

  def instagram_following_count
    Rails.cache.fetch("instagram-following-count-#{self.id}", :exprires_in => 3600) do
      instagram_client.user['counts']['follows']
    end
  end

  def instagram_media
    Rails.cache.fetch("instagram-media-#{self.id}", :exprires_in => 3600) do
      show_instagram? ? instagram_client.user_recent_media : []
    end
    #    instagram_client.user_recent_media.first['images']['standard_resolution']['url']
  end

  def twitter_follower_count
    Rails.cache.fetch("twitter-follower-count-#{self.id}", :exprires_in => 3600) do
      show_twitter? ? twitter_client.current_user.followers_count : 0
    end
  end

  def pinterest_follower_count
    #show_pinterest? ? pinterest_client.user_followed_by : 0
  end

  def total_social_count
     self.facebook_follower_count + self.instagram_follower_count + self.vine_follower_count + self.twitter_follower_count #+ self.pinterest_follower_count
  end

  def show_instagram?
    !! self.instagram_token
  end

  def show_facebook?
    !! self.facebook_token
  end

  def show_twitter?
    !! self.twitter_token
  end

  def show_pinterest?
    !! self.pinterest_token
  end

  def show_vine?
    !! self.vine_password
  end

  private

  def vine_client
    @vine_client ||= Vine::Client.new(self.vine_email, self.vine_password)
  end

  def pinterest_client
    @pinterest_client ||= Pinterest::Base.new(:access_token => self.pinterest_token)  
  end

  def twitter_client
    @twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = '3qTH5woXpYBQeOWwIFFimyrQa'
      config.consumer_secret     = 'TU4u1Y7DENtuJfszTsuPgU4ljXFV2gnd6TLyRCNM1RYFkBbtP3'
      config.access_token        = self.twitter_token
      config.access_token_secret = self.twitter_token_secret
    end
  end

  def instagram_client
    @instagram_client ||= Instagram.client(:access_token => self.instagram_token)
  end

  def facebook_client
    @facebook_client ||= Koala::Facebook::API.new(self.facebook_token)
  end
end