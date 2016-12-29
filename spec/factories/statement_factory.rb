FactoryGirl.define do
  factory :statement do
    text { Faker::Lorem.unique.sentence }
  end
end
