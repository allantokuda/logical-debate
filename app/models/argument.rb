class Argument < ApplicationRecord
  belongs_to :statement
  has_many :premise_citations
  has_many :premises, through: :premise_citations, class_name: 'Statement', foreign_key: 'statement_id'

  validates_inclusion_of :agree, in: [true, false]
  validates :statement,      presence: true

  def agree_disagree
    agree ? 'Agree' : 'Disagree'
  end

  def can_be_published?
    premises.any?
  end

  def conclusion_overlaps(premise)
    overlaps = wordmap(statement.text)
    premise.words.each do |word|
      overlaps[word] += 1 if overlaps.key?(word)  
    end
  end

  private

  def wordmap(text)
    Hash[text.words.map { |word| [word, nil] }]
  end
end
