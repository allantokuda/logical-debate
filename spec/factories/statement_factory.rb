FactoryGirl.define do
  factory :statement do
    user
    text { Faker::Lorem.unique.sentence }
  end
end
