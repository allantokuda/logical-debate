class Statement < ApplicationRecord
  include UUID

  belongs_to :user

  has_many :arguments, dependent: :destroy, foreign_key: :subject_statement_id
  has_many :stances, dependent: :destroy

  before_validation :strip_text_whitespace
  before_validation :add_period

  belongs_to :countered_argument, class_name: 'Argument', optional: true

  validates_presence_of :text

  validate :one_statement, on: :create
  attr_accessor :verified_one_sentence

  after_create :notify_previous_user

  def subject
    countered_argument
  end

  # For now, mask the fact that there is no separate publish date.
  def published_at
    created_at
  end

  def words
    text.split(' ').map(&:strip)
  end

  def stance_of(user)
    return Stance.new(user: user, statement: self, agree: true) if user == self.user
    Stance.find_by(user: user, statement: self)
  end

  def agreed_by?(user)
    return true if user == self.user
    stance_of(user)&.agree
  end

  def allow_action?(user)
    stance_of(user).present? || user == self.user
  end

  def last_argument_by(user)
    arguments.where(user: user).last
  end

  def nested
    countered_argument.present?
  end

  def win?
    @win ||= begin
      return true if nested && disagreements.none? && agreements.none?
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

  def sentence_split
    text.strip.scan(/[^.!?]+[.!?]+\s*/).map(&:strip)
  end

  def likely_multiple_statements?
    sentence_split.count > 1
  end

  def breadcrumbs
    return [] unless countered_argument.present?
    countered_argument.breadcrumbs.concat([countered_argument])
  end

  private

  def agreements
    arguments.published.top_level.where(agree: true)
  end

  def disagreements
    arguments.published.top_level.where(agree: false)
  end

  def strip_text_whitespace
    text.strip!
  end

  def add_period
    self.text += '.' if text.present? && !(text[-1] =~ /[.!?]/)
  end

  def one_statement
    errors.add(:base, 'Please verify that this is only one sentence.') if likely_multiple_statements? && verified_one_sentence != '1'
  end

  def notify_previous_user
    ActivityNotificationMailer.notify_reply(self).deliver_now
  end
end
