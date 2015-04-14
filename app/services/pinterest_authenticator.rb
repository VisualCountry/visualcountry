class PinterestAuthenticator
  def initialize(user, auth_data)
    @user = user
    @auth_data = auth_data
  end

  def authenticate
    user.update(pinterest_token: pinterest_token)
  end

  private

  attr_reader :auth_data, :user

  def pinterest_token
    auth_data["credentials"]["token"]
  end
end
