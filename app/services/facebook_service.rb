class FacebookService < BaseService
  delegate :info, :media, to: :service_data

  def self.from_user(user)
    super(user, :facebook)
  end

  def follower_count
    info['total_count']
  end

  private

  def service_data
    @facebook ||= Rails.cache.fetch("facebook-data-#{service_token}") do
      OpenStruct.new(
        info: client.get_connections('me', 'friends').raw_response['summary']
      )
    end
  end

  def client
    @client ||= Koala::Facebook::API.new(service_token)
  end
end