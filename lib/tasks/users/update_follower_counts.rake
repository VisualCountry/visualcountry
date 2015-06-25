namespace :users do
  task update_follower_counts: [:environment] do
    User.all.each do |user|
      User::SOCIAL_PLATFORMS.each do |platform|
        next unless user.send("#{platform}_token")

        UpdateFollowerCountWorker.perform_async(user.id, platform)
      end
    end
  end
end
