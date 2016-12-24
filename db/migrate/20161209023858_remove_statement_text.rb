class RemoveStatementText < ActiveRecord::Migration[5.0]
  def change
    remove_column :arguments, :statement_text, :string
  end
end
