class Premise < ApplicationRecord
  belongs_to :statement
  belongs_to :argument

  has_many :arguments, foreign_key: :subject_premise_id

  delegate :text, to: :statement

  def num_agrees
    arguments.where(agree: true).count
  end

  def num_disagrees
    arguments.where(agree: false).count
  end

  def self.bulk_update_from_params(params)
    params.to_h.all? do |premise_id, premise_text|
      next unless premise = Premise.find(premise_id)
      if premise_text.present?
        premise.statement.update(text: premise_text)
      else
        premise.destroy
      end
    end
  end
end
