class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :uri
      t.string :image_url
      t.string :edemam_id

      t.timestamps
    end
  end
end
