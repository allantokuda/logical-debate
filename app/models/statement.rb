class Statement < ApplicationRecord
  belongs_to :user

  has_many :premises, dependent: :destroy
  has_many :arguments, dependent: :destroy, foreign_key: :subject_statement_id
  has_many :dependent_arguments, through: :premises

  belongs_to :countered_argument, class_name: 'Argument', optional: true

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

  def win?
    @win ||= begin
      return true if disagreements.none? && agreements.none? && countered_argument.present?
      # TODO: scope to top-voted arguments for sanity
      disagreements.none?(&:win?) && agreements.any?(&:win?)
    end
  end

  def lose?
    @lose ||= agreements.none?(&:win?) && disagreements.any?(&:win?)
  end

  def state
    return 'Unaddressed' if arguments.count == 0
    return 'Supported' if win?
    return 'Countered' if lose?
    'Disputed'
  end

  def icon
    return 'checkmark' if win?
    return 'x' if lose?
    'question'
  end

  private

  def agreements
    arguments.published.top_level.where(agree: true)
  end

  def disagreements
    arguments.published.top_level.where(agree: false)
  end
end
