class ArgumentPremise < ActiveRecord::Migration[5.0]
  def change
    add_column :arguments, :subject_premise_id, :integer, references: :premises
    rename_column :arguments, :statement_id, :subject_statement_id
  end
end
