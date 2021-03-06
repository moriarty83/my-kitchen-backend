require 'uri'
require 'rest-client'

class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:show, :update, :destroy]
  before_action :authorized

  ############################
  ## INDEX ROUTE GET /ingredients
  ############################
  def index

    @ingredients = User.find(@user.id).ingredients
    puts @ingredients
    render json: @ingredients
  end

  # GET /ingredients/1
  def show
    render json: @ingredient
  end

  ############################
  ## CREATE ROUTE POST /ingredients
  ############################
  def create
    puts @user
    user = User.find(@user.id)
    puts "name is #{ingredient_params[:name]}"

    # Check to see if INGREDIENT Already Exists
    name = ingredient_params[:name].titleize
    p name.capitalize
    foundIngredient = Ingredient.find_by(name: ingredient_params[:name].titleize)
    # puts "Params: #{ingredient_params}"
    # puts "name: #{ingredient_params[:name]}"
    # puts "foundIngredient: #{foundIngredient}"
    # puts Ingredient.exists?(@ingredient)
    # puts user.ingredients.exists?(@ingredient)
    # If the ingredient Exists
    if !!foundIngredient
      puts "Ingredient Found"
      # Check to see if the User already owns it.
        if user.ingredients.exists?(foundIngredient.id)
          puts "You already own this Ingredient"
          render json: @user.ingredients, status: :unprocessable_entity
        else
          @user_ingredient = UserIngredient.new(user_id: user.id, ingredient_id: foundIngredient.id)
          if @user_ingredient.save
            render json: @user.ingredients, status: :created, location: @user_ingredient
          else
            render json: @user_ingredient.errors, status: :unprocessable_entity
          end
        end
    else

       # If the ingredient doesn't exist, make API call to Edemam to get it:
       paramsURI = URI.encode(ingredient_params[:name])
       url = "https://api.edamam.com/api/food-database/v2/parser?app_id=#{ENV['INGREDIENT_ID']}&app_key=#{ENV['INGREDIENT_KEY']}&ingr=#{paramsURI}&nutrition-type=cooking"
       puts url
       response = RestClient.get(url)
       ingredient = JSON.parse(response)
       ingredient = ingredient["parsed"][0]["food"]
       puts ingredient
       # Create new object to make ingredient
       newIngredient = user.ingredients.create(:name=>ingredient["label"], :image_url=>ingredient["image"], :edemam_id=>ingredient["foodId"])
       puts newIngredient

      # @ingredient = {:name => ingredient["label"], :image_url => ingredient["image"]}

      if newIngredient.save
        render json: @user.ingredients, status: :created, location: user
      else

        render json: newIngredient.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /ingredients/1
  def update
    if @ingredient.update(ingredient_params)
      render json: @ingredient
    else
      render json: @ingredient.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ingredients/1
  def destroy
    @ingredient.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ingredient
      @ingredient = Ingredient.find_by(params[:name].capitalize)
    end

    # Only allow a list of trusted parameters through.
    def ingredient_params
      p params
      params.require(:ingredient).permit(:name, :edemam_id)
    end
end
