class Argument < ApplicationRecord
  belongs_to :statement
  has_many :premise_citations
  has_many :premises, through: :premise_citations, class_name: 'Statement'

  validates :agree,          presence: true
  validates :statement,      presence: true
  validates :statement_text, presence: true

  def agree_disagree
    agree ? 'Agree' : 'Disagree'
  end

  def can_be_published?
    premises.any?
  end

end
