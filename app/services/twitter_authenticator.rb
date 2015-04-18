class TwitterAuthenticator
  def initialize(user, auth_data)
    @user = user
    @auth_data = auth_data
  end

  def authenticate
    if find_user
      update_twitter_token(find_user)
    end
  end

  def credentials
    {
      access_token: token,
      name: name,
      token_secret: secret,
      uid: uid,
    }
  end

  private

  attr_reader :auth_data, :user

  def find_user
    @find_user ||=
      (user || User.find_by(twitter_uid: uid))
  end

  def update_twitter_token(user)
    user.update(
      twitter_uid: uid,
      twitter_token: token,
      twitter_token_secret: secret,
    )
    user
  end

  def name
    auth_data["info"]["name"]
  end

  def uid
    auth_data["uid"]
  end

  def token
    auth_data["credentials"]["token"]
  end

  def secret
    auth_data["credentials"]["secret"]
  end
end
