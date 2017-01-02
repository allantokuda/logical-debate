class Uuid < ActiveRecord::Migration[5.0]
  def change
    add_column :statements, :uuid, :string
    add_index  :statements, :uuid, unique: true

    add_column :arguments,  :uuid, :string
    add_index  :arguments,  :uuid, unique: true

    add_column :premises,   :uuid, :string
    add_index  :premises,   :uuid, unique: true

    # Give UUIDs where currently missing
    Statement.all.each(&:save)
    Argument.all.each(&:save)
    Premise.all.each(&:save)
  end
end
