class TopLevelStatements < ActiveRecord::Migration[5.0]
  def change
    add_column :statements, :top_level, :boolean, null: false, default: false
  end
end
