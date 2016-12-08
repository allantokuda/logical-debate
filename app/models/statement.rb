class Statement < ApplicationRecord
  has_many :premise_citations
  has_many :arguments
  has_many :dependent_arguments, through: :premise_citations
end
