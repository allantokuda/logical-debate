class Argument < ApplicationRecord
  include UUID

  belongs_to :user

  # Subject can be either a standalone Statement, or a Premise which is the use of a statement in an argument
  belongs_to :subject_statement, class_name: 'Statement', optional: true
  belongs_to :subject_premise, class_name: 'Premise', optional: true

  # An argument can address its parent argument
  belongs_to :parent_argument, class_name: 'Argument', optional: true
  has_many :child_arguments, dependent: :destroy, class_name: 'Argument', foreign_key: :parent_argument_id

  has_many :premises, dependent: :destroy
  has_many :votes,    dependent: :destroy
  has_many :counters, dependent: :destroy, class_name: 'Statement', foreign_key: :countered_argument_id

  validates_inclusion_of :agree, in: [true, false]
  validate :has_subject

  after_create :upvote_if_applicable

  def self.published
    where.not(published_at: nil)
  end

  def self.top_level
    where(parent_argument_id: nil)
  end

  def self.published_or_by_user(user)
    where('published_at is not null or arguments.user_id = ?', user.id)
  end

  def self.vote_order
    joins('LEFT JOIN votes ON votes.argument_id = arguments.id').group('arguments.id').order('count(votes.id) desc')
  end

  def premise_input_placeholder
    if premises.none?
      "Why do you #{agree ? 'support' : "disagree with" } this statement? Enter one premise per line."
    else
      "Expand on your other #{'premise'.pluralize(premises.count)} to form an argument."
    end
  end

  def text
    premises.map(&:text).join(' ').presence || '(No comment)'
  end

  def type
    return 'clarification' if parent_argument
    agree ? 'supporting argument' : 'counterargument'
  end

  def agree_disagree(context = nil)
    word = agree ? 'agree' : 'disagree'

    if context.is_a?(User) && context != user
      word + 's'
    else
      word
    end
  end

  def actionable_to_user?(subject_user)
    published? && user != subject_user && subject.stance_of(subject_user).present?
  end

  def prompt_user_for_stance?(subject_user)
    published? && user != subject_user && !subject.stance_of(subject_user).present?
  end

  def can_be_published?
    premises.any?
  end

  def conclusion_overlaps(premise)
    overlaps = wordmap(subject_statement.text)
    premise.words.each do |word|
      overlaps[word] += 1 if overlaps.key?(word)
    end
  end

  def subject
    subject_statement || subject_premise || Statement.new(text: '(No subject)')
  end

  def publish!
    touch(:published_at)
  end

  def published?
    published_at.present?
  end

  def win?
    premises.all?(&:win?) && counters.none?(&:win?)
  end

  def lose?
    !premises.all?(&:win?) || counters.any?(&:win?)
  end

  def state
    return 'Unaddressed' if counters.none?
    return 'Supported' if counters.none?(&:win?)
    'Countered'
  end

  def icon
    return 'checkmark' if win?
    return 'x' if lose?
    'question'
  end

  def breadcrumbs
    subject.breadcrumbs.concat([subject])
  end

  private

  def wordmap(text)
    Hash[text.words.map { |word| [word, nil] }]
  end

  def has_subject
    errors.add(:base, 'Must have subject statement or premise') unless subject.present?
  end

  def upvote_if_applicable
    if Vote.where(user: user, argument: self).none?
      Vote.create(user: user, argument: self)
    end
  end
end
