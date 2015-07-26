class VineAdapter
  def initialize(access_token, user)
    @access_token = access_token
    @user = user
  end

  def follower_count
    client.user.followerCount
  end

  def media
    @media ||= Rails.cache.fetch(media_cache_key, expires_in: 6.hours) do
      client.media
    end
  end

  private

  attr_reader :access_token, :user

  def media_cache_key
    "vine-media-#{access_token}-v2"
  end

  def client
    @client ||= Vine.new(access_token)
  rescue Vine::InvalidToken
    token = Vine.new(nil, user.vine_email, user.vine_password).token
    user.update(vine_token: token)
    retry
  end
end
