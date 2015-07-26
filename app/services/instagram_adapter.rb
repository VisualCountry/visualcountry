class InstagramAdapter
  def initialize(access_token, user)
    @access_token = access_token
    @user = user
  end

  def follower_count
    handle_exception { client.user.counts.followed_by }
  end

  def media
    handle_exception do
      @media ||= Rails.cache.fetch(media_cache_key, expires_in: 6.hours) do
        client.user_recent_media
      end
    end
  end

  private

  attr_reader :access_token, :user

  def media_cache_key
    "instagram-media-#{access_token}-v2"
  end

  def client
    @client ||= Instagram.client(access_token: access_token)
  end

  def handle_exception(&block)
    yield
  rescue Instagram::BadRequest
    user.update(instagram_token: nil)
    false
  end
end
