FactoryGirl.define do
  sequence :email do |i|
    "user_#{i}@example.com"
  end

  sequence :username do |i|
    "pickle_#{i}"
  end

  sequence :name do |i|
    "Pickle Lee #{i}"
  end

  factory :user do
    email
    username
    name
    city 'New York City'
    bio 'Coolest dog ever.'
    password 'testtest'
    password_confirmation 'testtest'
  end
end
