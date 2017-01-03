class Stance < ApplicationRecord
  belongs_to :user
  belongs_to :statement

  validates_uniqueness_of :user_id, :scope => [:statement_id]

  def to_s
    agree ? 'agree' : 'disagree'
  end
end
