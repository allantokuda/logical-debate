class ForeignKeys < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :arguments, :statements, column: :subject_statement_id
    add_foreign_key :arguments, :premises, column: :subject_premise_id
  end
end
