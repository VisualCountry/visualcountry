class User < ActiveRecord::Base
  SOCIAL_PLATFORMS = %w(vine twitter instagram facebook pinterest)

  #after_save :find_or_create_profile #TODO: Remove comment after rake task has been run

  belongs_to :profile

  validates :password, length: { in: 6..128 }, on: :update, allow_blank: true

  scope :by_created_at, -> { order(created_at: :desc) }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable,
         omniauth_providers: [:facebook, :instagram, :twitter, :pinterest]

  delegate :media, to: :instagram, prefix: true, allow_nil: true
  delegate :media, to: :vine, prefix: true, allow_nil: true

  #TODO: Remove Paperclip attributes. Required for populate_profiles rake task
  has_attached_file :picture,
    default_url: 'missing.png',
    styles: {
      medium: '300x300#',
      thumb: '50x50#'
    }
  crop_attached_file :picture
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

  def find_or_create_profile
    profile || create_profile
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

  def instagram_account
    @instagram ||= InstagramAdapter.new(instagram_token, self)
  end

  def vine_account
    @vine ||= VineAdapter.new(vine_token, self)
  end

  def twitter_account
    @twitter ||= TwitterAdapter.from_user(self)
  end

  def facebook_account
    @facebook ||= FacebookAdapter.from_user(self)
  end

  protected

  def confirmation_required?
    facebook_token? ? false : true
  end
end
