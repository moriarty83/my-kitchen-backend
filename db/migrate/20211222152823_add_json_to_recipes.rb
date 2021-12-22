class AddJsonToRecipes < ActiveRecord::Migration[6.1]
  def change
    add_column :recipes, :json, :text
    remove_columns :recipes, :uri, :image_url, :edemam_id
  end
end
