FactoryGirl.define do
  factory :influencer_list do
    owner factory: :user
    sequence(:name) { |i| "Influencer List ##{i}" }
  end
end
