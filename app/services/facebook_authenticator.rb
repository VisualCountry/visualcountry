class FacebookAuthenticator
  def initialize(auth_data)
    @auth_data = auth_data
  end

  def authenticate
    update_facebook_token(find_or_create_user)
  end

  private

  attr_reader :auth_data

  def find_or_create_user
    User.find_or_create_by(email: email) do |user|
      user.email = email
      user.gender = gender
      user.name = name
      user.password = Devise.friendly_token
    end
  end

  def update_facebook_token(user)
    if can_update_facebook_token?
      user.update_without_password(
        facebook_token: token,
        facebook_token_expiration: expiry,
      )
      user
    end
  end

  def can_update_facebook_token?
    auth_data["credentials"] &&
      auth_data["credentials"]["token"] &&
      auth_data["credentials"]["expires_at"]
  end

  def name
    auth_data["extra"]["raw_info"]["name"]
  end

  def gender
    User.genders[auth_data["extra"]["raw_info"]["name"]]
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
