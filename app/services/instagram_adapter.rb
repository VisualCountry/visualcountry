class InstagramAdapter < BaseAdapter
  def self.from_user(user)
    super(user, :instagram)
  end

  def follower_count
    client.user.counts.followed_by
  end

  def media
    @media ||= Rails.cache.fetch(media_cache_key, expires_in: 6.hours) do
      client.user_recent_media
    end
  end

  private

  def media_cache_key
    "instagram-media-#{service_token}-v2"
  end

  def client
    @client ||= Instagram.client(access_token: service_token)
  end
end