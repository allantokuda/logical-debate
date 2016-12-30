class Authors < ActiveRecord::Migration[5.0]
  def change
    add_column :arguments, :user_id, :integer
    add_foreign_key :arguments, :users
  end
end
