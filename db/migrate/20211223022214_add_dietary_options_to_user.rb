class AddDietaryOptionsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :nickname, :string
    add_column :users, :vegan, :boolean, default: false
    add_column :users, :vegetarian, :boolean, default: false
    add_column :users, :low_fat, :boolean, default: false
    add_column :users, :gluten_free, :boolean, default: false
    add_column :users, :dairy_free, :boolean, default: false
    add_column :users, :peanut_free, :boolean, default: false
  end
end
