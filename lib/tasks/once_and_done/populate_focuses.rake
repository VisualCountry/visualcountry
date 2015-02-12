namespace :once_and_done do
  task populate_focuses: :environment do
    focuses = %w(
     Director
     Vlogger
     MUA
     Stylist
     Editor
     Illustrator
     Blogger
     Model
     Dancer
     Hair Stylist
     Set Designer
     Photographer
     Animator
     Actor
     Production Assistant
    )

    focuses.each do |focus|
      puts "creating #{focus} focus"
      Focus.create(name: focus)
    end
  end
end