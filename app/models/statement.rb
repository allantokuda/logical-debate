class Statement < ApplicationRecord
  has_many :premises, dependent: :destroy, foreign_key: :subject_premise_id
  has_many :arguments, dependent: :destroy, foreign_key: :subject_statement_id
  has_many :dependent_arguments, through: :premises

  def words
    text.split(' ').map(&:strip)
  end
end
