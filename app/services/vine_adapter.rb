class VineAdapter
  def initialize(user)
    @user = user
    @token = user.vine_token
  end

  def self.from_user(user)
    new(user)
  end

  def follower_count
    return unless token

    client.user.followerCount
  end

  def media
    return unless token

    @media ||= Rails.cache.fetch(media_cache_key, expires_in: 24.hours) do
      client.media
    end
  end

  private

  attr_reader :user, :token

  def media_cache_key
    "vine-media-#{token}-v2"
  end

  def client
    @client ||= Vine.new(token)
  rescue Vine::InvalidToken
    token = Vine.new(nil, user.vine_email, user.vine_password).token
    user.update(vine_token: token)
    retry
  end
end
