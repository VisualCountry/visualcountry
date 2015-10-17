namespace :once_and_done do
  task populate_profiles: :environment do
    User.all.each do |user|
      MigrateUserToProfile.perform(user.id)
      puts
    end
  end
end
