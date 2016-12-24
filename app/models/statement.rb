class Statement < ApplicationRecord
  has_many :premise_citations, foreign_key: 'statement_id'
  has_many :arguments
  has_many :dependent_arguments, through: :premise_citations

  def words
    text.split(' ').map(&:strip)
  end
end
