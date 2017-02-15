require 'faker'

FactoryGirl.define do
  factory :argument do
    user
    association :subject_statement, factory: :statement
    agree true
    text { Faker::Lorem.unique.sentence }

    trait :published do
      published_at Time.zone.now
    end
  end
end
