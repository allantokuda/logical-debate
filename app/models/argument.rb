class Argument < ApplicationRecord
  belongs_to :statement
  has_many :premise_citations
  has_many :premises, through: :premise_citations, class_name: 'Statement'

  validates_inclusion_of :agree, in: [true, false]
  validates :statement,      presence: true
  validates :statement_text, presence: true

  def agree_disagree
    agree ? 'Agree' : 'Disagree'
  end

  def can_be_published?
    premises.any?
  end

  def statement_text_sentences
    # Need better algorithm for sentence detection later
    statement_text.split('.').map(&:strip).map { |s| "#{s}." }
  end

end
