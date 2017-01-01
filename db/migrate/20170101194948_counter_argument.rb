class CounterArgument < ActiveRecord::Migration[5.0]
  def change
    add_column :statements, :countered_argument_id, :integer
    add_foreign_key :statements, :arguments, column: :countered_argument_id, primary_key: :id
  end
end
