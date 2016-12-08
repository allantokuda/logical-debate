class CreatePremiseCitations < ActiveRecord::Migration[5.0]
  def change
    create_table :premise_citations do |t|
      t.integer :statement_id
      t.integer :argument_id

      add_foreign_key :premise_citations, :statements
      add_foreign_key :premise_citations, :arguments

      t.timestamps
    end
  end
end
