FactoryGirl.define do
  factory :profile do
    user
    sequence(:username) { |i| "pickle_#{i}" }
    sequence(:name) { |i| "Pickle Lee #{i}" }
    city 'New York City'
    bio 'Coolest dog ever.'
  end
end
