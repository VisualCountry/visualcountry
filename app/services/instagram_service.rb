class InstagramService < BaseService
  def self.from_user(user)
    super(user, :instagram)
  end

  def follower_count
    client.user.counts.followed_by
  end

  def media
    @media ||= Rails.cache.fetch("instagram-media-#{service_token}") do
      client.user_recent_media
    end
  end

  private

  def client
    @client ||= Instagram.client(access_token: service_token)
  end
end