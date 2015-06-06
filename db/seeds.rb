# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ActiveRecord::Base.transaction do
  interests = ["Animals", "Art/Design", "Celebrity", "Comedy", "Curation", "DIY", "Family Friendly", "Fashion", "Food", "Gaming", "Music", "News", "Photography", "Sports", "Technology", "Travel"]
  interests.map { |interest| Interest.create(name: interest) }

  focuses = ["Actor", "Animator", "Assistant", "Blogger", "Dancer", "Designer", "Director", "Editor", "Hair Stylist", "Illustrator", "Make Up Artist", "Model", "Photographer", "Production", "Set Designer", "Stylist", "Viner", "Youtuber", "Instagrammer", "Musician", "Writer", "Food Stylist", "Prop Stylist", "Artist", "Journalist", "Developer"]
  focuses.map { |focus| Focus.create(name: focus) }
end
