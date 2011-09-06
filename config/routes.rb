Auth::Application.routes.draw do

  match '/auth/:provider/callback' => 'authentications#create'
  match '/auth/failure' => 'authentications#failure'
  match "/sign_out" => "sessions#destroy", :as => "sign_out"
  match "/sign_in" => "sessions#new", :as => "sign_in"
  match "/sign_up" => "users#new", :as => "sign_up"
  root :to => "authentications#index"
  resources :users
  resources :sessions
  resources :authentications
  resources :password_resets
end