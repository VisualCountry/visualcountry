namespace :once_and_done do
  task populate_profiles: :environment do
    User.all.each do |user|
      puts "Creating profile for #{user.name}"
      user.create_profile(
        user_id: user.id,
        created_at: user.created_at,
        updated_at: user.updated_at,
        picture: user.picture,
        username: user.username,
        name: user.name,
        city: user.city,
        bio: user.bio,
        website: user.website,
        instagram_follower_count: user.cached_instagram_follower_count,
        twitter_follower_count: user.cached_twitter_follower_count,
        vine_follower_count: user.cached_vine_follower_count,
        facebook_follower_count: user.cached_facebook_follower_count,
        pinterest_follower_count: user.cached_pinterest_follower_count,
        total_follower_count: user.total_follower_count,
        gender: user.gender,
        latitude: user.latitude,
        longitude: user.longitude,
        birthday: user.birthday,
        ethnicity: user.ethnicity,
        special_interests: user.special_interests,
      )
    end
  end
end
