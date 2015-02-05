FactoryGirl.define do

  factory :user do
    email 'pickle@gmail.com'
    username 'pickle'
    name 'Pickle Lee'
    city 'New York City'
    bio 'Coolest dog ever.'
    password 'testtest'
    password_confirmation 'testtest'
  end

end