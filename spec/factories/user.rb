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
  end
end
