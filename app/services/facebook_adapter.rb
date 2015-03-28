class FacebookAdapter < BaseAdapter
  def self.from_user(user)
    super(user, :facebook)
  end

  def follower_count
    client.get_connections('me', 'friends').raw_response['summary']['total_count']
  end

  private

  def client
    @client ||= Koala::Facebook::API.new(service_token)
  end
end