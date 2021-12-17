Rails.application.routes.draw do
  resources :recipe_ingredients
  resources :user_recipes
  resources :recipes
  resources :user_ingredients
  resources :ingredients
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resource :users, only: [:create]
  post "/login", to: "users#login"
  get "/auto_login", to: "users#auto_login"
end
