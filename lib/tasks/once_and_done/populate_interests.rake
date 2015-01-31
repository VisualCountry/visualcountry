namespace :once_and_done do
  task populate_interests: :environment do
    interests = %w(
      Fashion
      Art/Design
      Comedy
      Family Friendly
      Animals
      Gaming
      Sports
      Music
      DIY
      Celebrity
      Photography
      Travel
      News
      Technology
      Food
      Curation
    )

    interests.each do |interest|
      puts "creating #{interest} interest"
      Interest.create(name: interest)
    end
  end
end
