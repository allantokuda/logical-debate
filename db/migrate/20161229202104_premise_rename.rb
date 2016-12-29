class PremiseRename < ActiveRecord::Migration[5.0]
  def change
    rename_table :premise_citations, :premises
  end
end
