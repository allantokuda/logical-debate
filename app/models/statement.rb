class Statement < ApplicationRecord
  has_many :premise_citations
  has_many :arguments, through: :premise_citations
end
