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

  def state
    return 'Unaddressed' if arguments.count == 0
    case argument_diff
    when 1 then 'More agreements' # TODO: replace with 'Strong' once algorithm exists
    when -1 then 'More disagreements' # TODO: replace with 'Countered' once algorithm exists
    else 'Disputed'
    end
  end

  def icon
    return 'checkmark' if arguments.count == 0
    case argument_diff
    when 1 then 'checkmark'
    when -1 then 'x'
    else 'question'
    end
  end

  private

  def argument_diff
    # temporary oversimplistic approach
    @diff ||= arguments.published.top_level.where(agree: true).count <=>
              arguments.published.top_level.where(agree: false).count
  end
end
