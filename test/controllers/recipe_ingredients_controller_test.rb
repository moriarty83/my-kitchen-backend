require "test_helper"

class RecipeIngredientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recipe_ingredient = recipe_ingredients(:one)
  end

  test "should get index" do
    get recipe_ingredients_url, as: :json
    assert_response :success
  end

  test "should create recipe_ingredient" do
    assert_difference('RecipeIngredient.count') do
      post recipe_ingredients_url, params: { recipe_ingredient: { ingredient_id: @recipe_ingredient.ingredient_id, recipe_id: @recipe_ingredient.recipe_id } }, as: :json
    end

    assert_response 201
  end

  test "should show recipe_ingredient" do
    get recipe_ingredient_url(@recipe_ingredient), as: :json
    assert_response :success
  end

  test "should update recipe_ingredient" do
    patch recipe_ingredient_url(@recipe_ingredient), params: { recipe_ingredient: { ingredient_id: @recipe_ingredient.ingredient_id, recipe_id: @recipe_ingredient.recipe_id } }, as: :json
    assert_response 200
  end

  test "should destroy recipe_ingredient" do
    assert_difference('RecipeIngredient.count', -1) do
      delete recipe_ingredient_url(@recipe_ingredient), as: :json
    end

    assert_response 204
  end
end
