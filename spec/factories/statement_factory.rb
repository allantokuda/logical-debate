FactoryGirl.define do
  factory :statement do
    text 'Politicians are untrustworthy.'

    factory :premise do
      text ['Trust is hard won.', 'Politically driven policy challenges trust.', 'Trustworthiness is a matter of perspective.'].sample
    end
  end
end