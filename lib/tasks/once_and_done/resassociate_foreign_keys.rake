namespace :once_and_done do
  task reassociate_foreign_keys: :environment do
    puts "Clients\n"

    Client.all.each do |client|
      puts "Creating associations to profiles for #{client.name}"
      user_ids = client.users.pluck(:id)
      client.profiles = Profile.where(user_id: user_ids)
    end

    puts "Focuses\n"

    Focus.all.each do |focus|
      puts "Creating associations to profiles for #{focus.name}"
      user_ids = focus.users.pluck(:id)
      focus.profiles = Profile.where(user_id: user_ids)
    end

    puts "Interests\n"

    Interest.all.map do |interest|
      puts "Creating associations to profiles for #{interest.name}"
      user_ids = interest.users.pluck(:id)
      interest.profiles = Profile.where(user_id: user_ids)
    end

    puts "Press\n"

    Press.all.map do |press|
      puts "Creating associations to profiles for #{press.name}"
      user = User.find_by(id: press.user_id)
      press.update(profile_id: user.profile.id) if user
    end

    puts "List Memberships\n"

    ListMembership.all.map do |membership|
      puts "Creating association to profile for #{membership.influencer_list.name}"
      membership.update(profile: Profile.find_by(user_id: membership.user_id))
    end

    puts "Influencer Lists\n"

    InfluencerList.all.map do |list|
      puts "Updating owner of #{list.name}"
      list.update(owner: Profile.find_by(user_id: list.user_id))
    end
  end
end
