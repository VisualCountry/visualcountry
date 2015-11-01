class User < ActiveRecord::Base
  # HACK: Because the sign up page requires information that needs to make its
  # way to the corresponding Profile, we need a way to temporarily store those
  # attributes until the create_profile after_action is called. This can
  # eventually be refactored into an action object.
  attr_accessor :name, :username

  has_many :influencer_lists, dependent: :destroy
  has_one :profile

  after_create :create_profile

  validates :password, length: { in: 6..128 }, on: :update, allow_blank: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable,
         omniauth_providers: [:facebook, :instagram, :twitter, :pinterest]

  def create_profile
    profile || Profile.create(user_id: id, name: name, username: username)
  end

  def profile
    reload
    super()
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

  def owns_list?(list)
    list.owner == self
  end

  def can_manage_list?(list)
    return true if admin?
    return true if list.owner == self

    list.organizations.where(id: profile.organization_ids).any?
  end

  protected

  def confirmation_required?
    facebook_token? ? false : true
  end
end
