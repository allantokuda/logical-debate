require 'faker'

FactoryGirl.define do
  factory :argument do
    user
    association :subject_statement, factory: :statement
    agree true

    trait :published do
      published_at Time.zone.now
    end
  end
end
