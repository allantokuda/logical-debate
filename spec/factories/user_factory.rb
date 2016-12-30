FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'cogency'
  end
end
