FactoryGirl.define do
  sequence :email do |i|
    "user_#{i}@example.com"
  end

  factory :user do
    email
    password "testtest"
    password_confirmation "testtest"
    confirmed_at { 1.day.ago }

    factory :admin do
      admin true
    end

    trait :with_twitter do
      twitter_token "twitter-token"
    end

    trait :with_instagram do
      instagram_token "instagram-token"
    end
  end
end
