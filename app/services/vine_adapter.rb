class VineAdapter < BaseAdapter
  def self.from_user(user)
    super(user, :vine)
  end

  def follower_count
    client.user.followerCount
  end

  def media
    #@media ||= Rails.cache.fetch("vine-media-#{service_token}") do
      client.media
    #end
  end

  private

  def client
    #@client ||= Vine.new(service_token)
    Vine.new(service_token)
  rescue Vine::InvalidToken
    reauthenticate_vine_with_credentials
    retry
  end

  def reauthenticate_vine_with_credentials
    token = Vine.new(nil, user.vine_email, user.vine_password).token
    user.update(vine_token: token)
  rescue Vine::InvalidUsernameOrPassword
    #TODO: send email to user
  end
end
