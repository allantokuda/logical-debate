class ParentArgument < ActiveRecord::Migration[5.0]
  def change
    add_column :arguments, :parent_argument_id, :integer

    add_foreign_key :arguments, :arguments, column: :parent_argument_id, primary_key: :id
  end
end
