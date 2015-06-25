class VineAdapter < BaseAdapter
  def self.from_user(user)
    super(user, :vine)
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

  def media_cache_key
    "vine-media-#{service_token}-v2"
  end

  def client
    @client ||= Vine.new(service_token)
  rescue Vine::InvalidToken
    token = Vine.new(nil, user.vine_email, user.vine_password).token
    user.update(vine_token: token)
    retry
  end
end