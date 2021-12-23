class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :update, :destroy]

  # GET /recipes
  def index
    @recipes = User.find(@user.id).recipes

    render json: @recipes.select("json")
  end

  # GET /recipes/1
  def show
    render json: @recipe
  end

  # POST /recipes
  def create
    user = User.find(@user.id)

    puts "name #{recipe_params[:name]}"

    # Check to see if RECIPE Already Exists
    foundRecipe = Recipe.find_by(name: recipe_params[:name])
    puts "foundRecipe: #{foundRecipe}"
    # If the recipe Exists
    if !!foundRecipe
      puts "Recipe Found"
      # Check to see if the User already owns it.
      if UserRecipe.exists?(foundRecipe.id)
        puts "You already own this Recipe"
        render json: {"message": "You already have this Recipe"}
      else
        # If the recipe exists, but the user doesn't own it
        puts "You don't own this recipe, but it exists"
        @user_recipe = UserRecipe.new(user_id: user.id, recipe_id: foundRecipe.id)
        if @user_recipe.save
          render json: @user_recipe, status: :created, location: @user_recipe
        else
          render json: @user_recipe.errors, status: :unprocessable_entity
        end
      end
    else

       # If the recipe doesn't exist, make API call to Edemam to get it:
      puts "hello"
      puts recipe_params

      @recipe = Recipe.new(:name => recipe_params["name"], :json => recipe_params["json"])

      if @recipe.save
        render json: @recipe, status: :created, location: @recipe
      else

        render json: @recipe.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /recipes/1
  def update
    if @recipe.update(recipe_params)
      render json: @recipe
    else
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  # DELETE /recipes/1
  def destroy
    @recipe.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      puts "wee!"
      puts params
      @recipe = Recipe.find(params[:name])
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.require(:recipe).permit(:name, :json)
    end
end
