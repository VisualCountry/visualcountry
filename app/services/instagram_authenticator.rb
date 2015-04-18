class InstagramAuthenticator
  def initialize(user, auth_data)
    @user = user
    @auth_data = auth_data
  end

  def authenticate
    user.update(instagram_token: instagram_token)
  end

  private

  attr_reader :auth_data, :user

  def instagram_token
    auth_data["credentials"]["token"]
  end
end
