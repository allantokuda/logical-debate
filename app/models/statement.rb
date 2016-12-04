class Statement < ApplicationRecord
  belongs_to :parent_statement, class_name: "Statement", optional: true

  has_many :child_statements, class_name: "Statment", foreign_key: "parent_statement_id"

  def has_parent?
    parent_statement.present?
  end
end
