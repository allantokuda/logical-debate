class Statement < ApplicationRecord
  belongs_to :user

  has_many :premises, dependent: :destroy
  has_many :arguments, dependent: :destroy, foreign_key: :subject_statement_id
  has_many :dependent_arguments, through: :premises

  def words
    text.split(' ').map(&:strip)
  end

  def stance_of(current_user)
    arguments.where(user: current_user).last&.agree_disagree(current_user)
  end
end
