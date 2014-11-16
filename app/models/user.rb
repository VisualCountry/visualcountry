class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :instagram]

  has_attached_file :picture
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  validates :password, length: { in: 6..128 }, on: :update, allow_blank: true

  has_many :presses
  accepts_nested_attributes_for :presses

  has_many :clients
  accepts_nested_attributes_for :clients


  def facebook_follower_count
    show_facebook? ? facebook_client.get_connections('me', 'friends').raw_response['summary']['total_count'] : 0
  end

  def instagram_follower_count
      show_instagram? ? instagram_client.user['counts']['followed_by'] : 0
  end

  def instagram_following_count
    instagram_client.user['counts']['follows']
  end

  def instagram_media
    show_instagram? ? instagram_client.user_recent_media : []
    #    instagram_client.user_recent_media.first['images']['standard_resolution']['url']
  end
  def total_social_count
     self.facebook_follower_count + self.instagram_follower_count 
  end

  def show_instagram?
    !! self.instagram_token
  end

  def show_facebook?
    !! self.facebook_token
  end

private


  def instagram_client
    @instagram_client ||= Instagram.client(:access_token => self.instagram_token)
  end

  def facebook_client
    @facebook_client ||= Koala::Facebook::API.new(self.facebook_token)
  end
end