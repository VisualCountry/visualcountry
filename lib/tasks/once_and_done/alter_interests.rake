namespace :once_and_done do
  task alter_focuses: :environment do
    NEW_FOCUS_MAPPINGS = {
      'Hair' => 'Hair Stylist',
      'MUA' => 'Make Up Artist',
      'Set' => 'Set Designer',
      'Production' => 'Producer'
    }

    NEW_FOCUS_MAPPINGS.map do |old, new|
      puts "Updating #{old} to #{new}"
      Focus.find_by(name: old).update(name: new)
    end

    puts "Removing second stylist"
    Focus.where(name: 'Stylist').last.destroy

    puts "Removing vlogger"
    Focus.find_by(name: 'Vlogger').destroy

    new_focuses = ['Viner', 'Youtuber', 'Instagrammer', 'Musician', 'Writer', 'Food Stylist', 'Prop Sylist', 'Artist', 'Journalist', 'Developer']

    new_focuses.each do |focus|
      puts "Creating #{focus}"
      Focus.create(name: focus)
    end
  end
end
