class RemoveIngredientsId < ActiveRecord::Migration[6.1]
  def change
    remove_column :ingredients, :edemam_id
  end
end
