FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'cogency'
    confirmed_at Time.zone.now
  end
end
