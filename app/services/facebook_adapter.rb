class FacebookAdapter
  def initialize(token)
    @token = token
  end

  def self.from_user(user)
    return unless token = user.facebook_token

    new(token)
  end

  def follower_count
    client.get_connections('me', 'friends').raw_response['summary']['total_count']
  end

  def permissions
    granted_permissions.map { |permission| permission.fetch('permission').to_sym }
  end

  def deauthenticate
    client.delete_connections('me', 'permissions')
  end

  private

  attr_reader :token

  def granted_permissions
    raw_permissions.select { |permission| permission.fetch('status') == 'granted' }
  end

  def raw_permissions
    client.get_connections('me', 'permissions')
  end

  def client
    @client ||= Koala::Facebook::API.new(token)
  end
end
