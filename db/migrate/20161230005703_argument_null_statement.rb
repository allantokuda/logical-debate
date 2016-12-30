class ArgumentNullStatement < ActiveRecord::Migration[5.0]
  def change
    change_column :arguments, :subject_statement_id, :integer, null: true
  end
end
