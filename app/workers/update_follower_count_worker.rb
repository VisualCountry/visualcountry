class UpdateFollowerCountWorker
  include Sidekiq::Worker

  def perform(profile_id, platform)
    UpdateFollowerCount.new(profile_id, platform).perform
  end
end
