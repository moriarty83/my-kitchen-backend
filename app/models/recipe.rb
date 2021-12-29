class Recipe < ApplicationRecord
    has_many :recipe_ingredients
    has_many :ingredients, through: :recipe_ingredients
    
    has_many :user_recipes
    validates :name, uniqueness: true
    # has_many :users, through: :user_recipes
end
