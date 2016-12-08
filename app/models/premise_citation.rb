class PremiseCitation < ApplicationRecord
  belongs_to :premise, class_name: 'Statement'
  belongs_to :argument
end
