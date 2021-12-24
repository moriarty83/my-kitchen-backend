class DeleteDietaryPrefsFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_columns :users, :vegan, :vegetarian, :low_fat, :gluten_free, :dairy_free, :peanut_free
  end
end
