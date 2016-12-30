class NotNullPremises < ActiveRecord::Migration[5.0]
  def change
    change_column :premises, :argument_id,  :integer, null: false
    change_column :premises, :statement_id, :integer, null: false
  end
end
