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
  put "/users", to: "users#update"
  post "/users/delete", to: "users#delete"
  get "/users/delete-request", to:"users#delete_request", as: 'user'
  post 'password/forgot', to: 'password#forgot'
  post 'password/reset', to: 'password#reset'
end
