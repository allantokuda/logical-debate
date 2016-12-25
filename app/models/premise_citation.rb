class PremiseCitation < ApplicationRecord
  belongs_to :premise, class_name: 'Statement', foreign_key: 'statement_id'
  belongs_to :argument

  delegate :text, to: :premise
end
