class RemoveStatementReflexive < ActiveRecord::Migration[5.0]
  def change
    remove_column :statements, :parent_statement_id, :integer
    remove_column :statements, :agree, :boolean
  end
end
