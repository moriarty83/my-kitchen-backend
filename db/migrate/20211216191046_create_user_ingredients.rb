class CreateUserIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :user_ingredients do |t|
      t.integer :user_ie
      t.integer :ingredient_id

      t.timestamps
    end
  end
end
