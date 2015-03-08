class VineService < BaseService
  delegate :info, :media, to: :service_data

  def self.from_user(user)
    super(user, :vine)
  end

  def follower_count
    info.followerCount
  end

  private

  def service_data
    @vine ||= Rails.cache.fetch("vine-data-#{service_token}") do
      OpenStruct.new(
        media: client.media,
        info: client.user
      )
    end
  end

  def client
    @client ||= Vine.new(service_token)
  end
end