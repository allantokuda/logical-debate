class Premise < ApplicationRecord
  belongs_to :statement
  belongs_to :argument

  has_many :arguments, inverse_of: :subject_premise

  delegate :text, to: :statement
end
