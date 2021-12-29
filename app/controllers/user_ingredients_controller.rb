class UserIngredientsController < ApplicationController
  before_action :set_user_ingredient, only: [:show, :update, :destroy]


  # GET /user_ingredients
  def index
    @user_ingredients = UserIngredient.all

    render json: @user_ingredients
  end

  # GET /user_ingredients/1
  def show

    render json: @user_ingredient
  end

  # POST /user_ingredients
  def create
    @user_ingredient = UserIngredient.new(user_ingredient_params)

    if @user_ingredient.save
      render json: @user_ingredient, status: :created, location: @user_ingredient
    else
      render json: @user_ingredient.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_ingredients/1
  def update
    if @user_ingredient.update(user_ingredient_params)
      render json: @user_ingredient
    else
      render json: @user_ingredient.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_ingredients/:id
  def destroy
    puts "Deleting"
    @user_ingredient = UserIngredient.find_by(user_id: @user.id, ingredient_id: params[:id])
    if @user_ingredient.destroy 
      render json: @user.ingredients, status: :accepted
    else
      render json: @user.ingredinets, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_ingredient
      puts @user
      @user_ingredient = UserIngredient.find_by(user_id: @user.id, ingredient_id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_ingredient_params
      puts params
      params.require(:user_ingredient).permit(:user_id, :ingredient_id)
    end
end
