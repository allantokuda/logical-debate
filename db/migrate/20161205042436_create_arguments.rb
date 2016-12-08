class CreateArguments < ActiveRecord::Migration[5.0]
  def change
    create_table :arguments do |t|
      t.boolean :agree, null: false
      t.integer :statement_id, references: Statement, null: false
      t.text :statement_text, null: false

      t.timestamps
    end
  end
end
