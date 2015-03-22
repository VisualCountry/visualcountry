namespace :users do
  task update_follower_counts: [:environment] do
    User.all.each do |user|
      User::SOCIAL_PLATFORMS.each do |platform|
        next unless user.send("#{platform}_token")

        platform_follower_count = user.send("#{platform}_follower_count")
        if user.send("cached_#{platform}_follower_count=", platform_follower_count)
          puts "Updated #{user.email}'s cached_#{platform}_follower_count to #{platform_follower_count}"
        end

        user.save
      end
    end
  end
end
