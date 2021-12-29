class UserRecipesController < ApplicationController
  before_action :set_user_recipe, only: [:show, :update]

  # GET /user_recipes
  def index
    @user_recipes = UserRecipe.all

    render json: @user_recipes
  end

  # GET /user_recipes/1
  def show
    render json: @user_recipe
  end

  # POST /user_recipes
  def create
    @user_recipe = UserRecipe.new(user_recipe_params)

    if @user_recipe.save
      render json: @user_recipe, status: :created, location: @user_recipe
    else
      render json: @user_recipe.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_recipes/1
  def update
    if @user_recipe.update(user_recipe_params)
      render json: @user_recipe
    else
      render json: @user_recipe.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_recipes/1
  def destroy
    recipe = UserRecipe.find_by(user_id: @user.id, recipe_id: params[:id])
    if recipe.destroy
      render json: recipe, status: :accepted
    else
      render json: recipe 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_recipe
      @user_recipe = UserRecipe.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_recipe_params
      params.require(:user_recipe).permit(:user_id, :recipe_id)
    end
end
