class Argument < ApplicationRecord
  belongs_to :user

  # Subject can be either a standalone Statement, or a Premise which is the use of a statement in an argument
  belongs_to :subject_statement, class_name: 'Statement', optional: true
  belongs_to :subject_premise, class_name: 'Premise', optional: true

  has_many :premises, dependent: :destroy

  validates_inclusion_of :agree, in: [true, false]
  validate :has_subject

  def self.published
    where.not(published_at: nil)
  end

  def premise_input_placeholder
    if premises.none?
      "Why do you #{agree_disagree.downcase}? Enter one premise per line."
    else
      "Expand on your other #{'premise'.pluralize(premises.count)} to form an argument."
    end
  end

  def one_line
    premises.map(&:text).join(' ').presence || '(No comment)'
  end

  def agree_disagree
    agree ? 'Agree' : 'Disagree'
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
    subject_statement || subject_premise
  end

  def publish!
    touch(:published_at)
  end

  def published?
    published_at.present?
  end

  private

  def wordmap(text)
    Hash[text.words.map { |word| [word, nil] }]
  end

  def has_subject
    errors.add(:base, 'Must have subject statement or premise') unless subject.present?
  end
end
