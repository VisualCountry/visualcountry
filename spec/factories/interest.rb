FactoryGirl.define do
  factory :interest do
    sequence(:name) { |n| "The #{n.ordinalize} coolest interest" }
  end
end
