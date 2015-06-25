class UpdateFollowerCountWorker
  include Sidekiq::Worker

  def perform(user_id, platform)
    user = User.find(user_id)
    cached_follower_count_attribute = "cached_#{platform}_follower_count"
    follower_count_from_platform = user.send(platform).follower_count

    user.update(cached_follower_count_attribute => follower_count_from_platform)
  end
end
