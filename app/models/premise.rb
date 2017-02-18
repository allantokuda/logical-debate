class Premise < ApplicationRecord
  # temporary to enable migration
  belongs_to :argument
  belongs_to :statement

  delegate :text, to: :statement
end
