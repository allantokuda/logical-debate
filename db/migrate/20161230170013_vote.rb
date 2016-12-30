class Vote < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer :argument_id, null: false
      t.integer :user_id, null: false
      t.datetime :created_at, null: false
    end

    add_foreign_key :votes, :users
    add_foreign_key :votes, :arguments
  end
end
