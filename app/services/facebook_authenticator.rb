class FacebookAuthenticator
  def initialize(auth_data, user = nil)
    @auth_data = auth_data
    @user = user
  end

  def self.from_current_user(current_user, auth_data)
    new(auth_data, current_user).authenticate
  end

  def self.from_facebook_login(auth_data)
    new(auth_data).authenticate
  end

  def authenticate
    @user ||= find_or_create_user

    update_facebook_data
  end

  private

  attr_accessor :user
  attr_reader :auth_data

  def find_or_create_user
    existing_user || create_user
  end

  def existing_user
    user_from_facebook_uid = User.find_by(facebook_uid: uid)
    user_from_facebook_email = User.find_by(email: email)

    user_from_facebook_uid || user_from_facebook_email
  end

  def create_user
    user = User.create(facebook_uid: uid, email: email) do |user|
      user.email = email
      user.facebook_uid = uid
      user.password = Devise.friendly_token
    end

    user.reload
    user.profile.update(gender: gender, name: name)
    user
  end

  def update_facebook_data
    if can_update_facebook_token?
      user.update_without_password(
        facebook_token: token,
        facebook_token_expiration: expiry,
        facebook_uid: uid
      )
      user
    end
  end

  def can_update_facebook_token?
    auth_data["credentials"] &&
      auth_data["credentials"]["token"] &&
      auth_data["credentials"]["expires_at"]
  end

  def uid
    auth_data["uid"]
  end

  def name
    auth_data["extra"]["raw_info"]["name"]
  end

  def gender
    Profile.genders[auth_data["extra"]["raw_info"]["gender"]]
  end

  def email
    auth_data["info"]["email"]
  end

  def token
    auth_data["credentials"]["token"]
  end

  def expiry
    Time.at(auth_data["credentials"]["expires_at"])
  end
end
