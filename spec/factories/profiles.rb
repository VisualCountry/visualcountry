FactoryGirl.define do
  factory :profile do
    sequence(:username) { |i| "pickle_#{i}" }
    sequence(:name) { |i| "Pickle Lee #{i}" }
    city 'New York City'
    bio 'Coolest dog ever.'
  end
end
