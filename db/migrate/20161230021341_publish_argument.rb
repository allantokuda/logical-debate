class PublishArgument < ActiveRecord::Migration[5.0]
  def change
    add_column :arguments, :published_at, :datetime
  end
end
