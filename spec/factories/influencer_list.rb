FactoryGirl.define do
  factory :influencer_list do
    sequence(:name) { |i| "Influencer List ##{i}" }
  end
end
