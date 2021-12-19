class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:show, :update, :destroy]
  before_action :authorized

  ############################
  ## INDEX ROUTE GET /ingredients
  ############################
  def index

    @ingredients = User.find(@user.id).ingredients
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
    user = User.find(@user.id)

    # Check to see if INGREDIENT Already Exists
    foundIngredient = Ingredient.find_by(ingredient_params)
    # If the ingredient Exists
    if !!foundIngredient
      puts "Ingredient Found"
      # Check to see if the User already owns it.
      if UserIngredient.exists?(foundIngredient.id)
        puts "You already own this Ingredient"
        render json: {"message": "You already own this Ingredient"}
      else
        # If the ingredient exists, but the user doesn't own it
        puts "You don't own this ingredient, but it exists"
        @user_ingredient = UserIngredient.new(user_id: user.id, ingredient_id: foundIngredient.id)
        if @user_ingredient.save
          render json: @user_ingredient, status: :created, location: @user_ingredient
        else
          render json: @user_ingredient.errors, status: :unprocessable_entity
        end
      end
    else

      # If the ingredient doesn't exist, create it through the User.
      @ingredient = user.ingredients.new(ingredient_params)

      if @ingredient.save
        render json: @ingredient, status: :created, location: @ingredient
      else

        render json: @ingredient.errors, status: :unprocessable_entity
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
      @ingredient = Ingredient.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ingredient_params
      params.require(:ingredient).permit(:name, :edemam_id)
    end
end
