FactoryGirl.define do
  factory :influencer_list do
    owner factory: :profile
    sequence(:name) { |i| "Influencer List ##{i}" }
  end
end
