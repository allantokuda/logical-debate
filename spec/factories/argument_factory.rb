require 'faker'

FactoryGirl.define do
  factory :argument do
    association :subject_statement, factory: :statement
    agree true
  end
end
