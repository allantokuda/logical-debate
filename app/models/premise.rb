class Premise < ApplicationRecord
  belongs_to :statement
  belongs_to :argument

  has_many :arguments, foreign_key: :subject_premise_id

  delegate :text, to: :statement

  def num_agrees
    arguments.where(agree: true).count
  end

  def num_disagrees
    arguments.where(agree: false).count
  end
end
