class Premise < ApplicationRecord
  belongs_to :statement
  belongs_to :argument

  delegate :text, to: :statement
end
