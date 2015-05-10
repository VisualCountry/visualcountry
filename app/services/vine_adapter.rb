class VineAdapter < BaseAdapter
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
  rescue Vine::InvalidToken
    token = Vine.new(nil, user.vine_email, user.vine_password).token
    user.update(vine_token: token)
    retry
  end
end