class CreateStatements < ActiveRecord::Migration[5.0]
  def change
    create_table :statements do |t|
      t.string :text
      t.integer :user_id
      t.integer :parent_statement_id, references: :statements

      t.timestamps
    end
  end
end
