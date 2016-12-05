class AgreeBoolean < ActiveRecord::Migration[5.0]
  def change
    add_column :statements, :agree, :boolean
  end
end
