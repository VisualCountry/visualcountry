class VineService < BaseService
  def self.from_user(user)
    super(user, :vine)
  end

  def follower_count
    client.user.followerCount
  end

  def media
    @media ||= Rails.cache.fetch("vine-media-#{service_token}") do
      client.media
    end
  end

  private

  def client
    @client ||= Vine.new(service_token)
  end
end