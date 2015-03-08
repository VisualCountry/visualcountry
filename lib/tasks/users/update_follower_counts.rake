namespace :users do
  task update_follower_counts: [:environment] do
    User.all.each do |user|
      User::SOCIAL_PROFILES.each do |profile|
        next unless user.send("#{profile}_token")

        profile_follower_count = user.send("#{profile}_follower_count")
        if user.send("cached_#{profile}_follower_count=", profile_follower_count)
          puts "Updated #{user.email}'s cached_#{profile}_follower_count to #{profile_follower_count}"
        end
      end
    end
  end
end
