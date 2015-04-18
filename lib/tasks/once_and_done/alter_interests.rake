namespace :once_and_done do
  task alter_interests: :environment do
    Interest.find_by(name: "Family").update(name: "Family Friendly")
    Interest.find_by(name: "Friendly").destroy
  end
end