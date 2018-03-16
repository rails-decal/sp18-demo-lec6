class AddAssociations < ActiveRecord::Migration[5.1]
  def change
    add_column :reviews, :user_id, :integer
    add_column :reviews, :restaurant_id, :integer
    add_index :reviews, :user_id
    add_index :reviews, :restaurant_id
  end
end
