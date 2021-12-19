class Ingredient < ApplicationRecord
    has_many :users_ingredients
    has_many :recipe_ingredients

    validates :name, uniqueness: true
    # has_many :recipes, through :recipe_ingredients
end
