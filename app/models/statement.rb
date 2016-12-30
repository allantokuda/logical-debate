class Statement < ApplicationRecord
  belongs_to :user

  has_many :premises, dependent: :destroy
  has_many :arguments, dependent: :destroy, foreign_key: :subject_statement_id
  has_many :dependent_arguments, through: :premises

  def words
    text.split(' ').map(&:strip)
  end

  def stance_of(user)
    last_argument_by(user)&.agree_disagree(user)
  end

  def agreed_by?(user)
    last_argument_by(user)&.agree
  end

  def last_argument_by(user)
    arguments.where(user: user).last
  end
end
