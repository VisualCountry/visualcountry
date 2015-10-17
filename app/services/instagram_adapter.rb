class InstagramAdapter
  def initialize(token)
    @token = token
  end

  def self.from_user(user)
    new(user.instagram_token)
  end

  def follower_count
    return unless token

    handle_exception { client.user.counts.followed_by }
  end

  def media
    return unless token

    handle_exception do
      @media ||= Rails.cache.fetch(media_cache_key, expires_in: 6.hours) do
        client.user_recent_media
      end
    end
  end

  private

  attr_reader :token

  def media_cache_key
    "instagram-media-#{token}-v2"
  end

  def client
    @client ||= Instagram.client(access_token: token)
  end

  def handle_exception(&block)
    yield
  rescue Instagram::BadRequest => exception
    user.update(instagram_token: nil)
    false
  end
end
