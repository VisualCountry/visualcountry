class InstagramService < BaseService
  delegate :info, :media, to: :service_data

  def self.from_user(user)
    super(user, :instagram)
  end

  def follower_count
    info.counts.followed_by
  end

  private

  def service_data
    @instagram ||= Rails.cache.fetch("instagram-data-#{service_token}") do
      OpenStruct.new(
        media: client.user_recent_media,
        info: client.user
      )
    end
  end

  def client
    @client ||= Instagram.client(access_token: service_token)
  end
end