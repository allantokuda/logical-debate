require 'faker'

FactoryGirl.define do
  factory :argument do
    user
    association :subject_statement, factory: :statement
    agree true
  end
end
