require "test_helper"

class UserRecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_recipe = user_recipes(:one)
  end

  test "should get index" do
    get user_recipes_url, as: :json
    assert_response :success
  end

  test "should create user_recipe" do
    assert_difference('UserRecipe.count') do
      post user_recipes_url, params: { user_recipe: { recipe_id: @user_recipe.recipe_id, user_id: @user_recipe.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show user_recipe" do
    get user_recipe_url(@user_recipe), as: :json
    assert_response :success
  end

  test "should update user_recipe" do
    patch user_recipe_url(@user_recipe), params: { user_recipe: { recipe_id: @user_recipe.recipe_id, user_id: @user_recipe.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy user_recipe" do
    assert_difference('UserRecipe.count', -1) do
      delete user_recipe_url(@user_recipe), as: :json
    end

    assert_response 204
  end
end
