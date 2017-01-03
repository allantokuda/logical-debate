class Stance < ActiveRecord::Migration[5.0]
  def change
    create_table :stances do |t|
      t.integer :user_id, null: false
      t.integer :statement_id, null: false
      t.boolean :agree  # null could mean explicitly declared neutral
    end

    add_foreign_key :stances, :users
    add_foreign_key :stances, :statements
  end
end
