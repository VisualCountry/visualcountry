class UpdateFollowerCountWorker
  include Sidekiq::Worker

  def perform(user_id, platform)
    UpdateFollowerCount.new(user_id, platform).perform
  end
end
