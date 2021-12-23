class AddFoodIdToIngredients < ActiveRecord::Migration[6.1]
  def change
    add_column :ingredients, :edemam_id, :string
  end
end
