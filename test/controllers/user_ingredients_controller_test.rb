require "test_helper"

class UserIngredientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_ingredient = user_ingredients(:one)
  end

  test "should get index" do
    get user_ingredients_url, as: :json
    assert_response :success
  end

  test "should create user_ingredient" do
    assert_difference('UserIngredient.count') do
      post user_ingredients_url, params: { user_ingredient: { ingredient_id: @user_ingredient.ingredient_id, user_ie: @user_ingredient.user_ie } }, as: :json
    end

    assert_response 201
  end

  test "should show user_ingredient" do
    get user_ingredient_url(@user_ingredient), as: :json
    assert_response :success
  end

  test "should update user_ingredient" do
    patch user_ingredient_url(@user_ingredient), params: { user_ingredient: { ingredient_id: @user_ingredient.ingredient_id, user_ie: @user_ingredient.user_ie } }, as: :json
    assert_response 200
  end

  test "should destroy user_ingredient" do
    assert_difference('UserIngredient.count', -1) do
      delete user_ingredient_url(@user_ingredient), as: :json
    end

    assert_response 204
  end
end
