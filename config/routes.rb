Auth::Application.routes.draw do
  match '/auth/:provider/callback' => 'authentications#create'
  match '/auth/failure' => 'authentications#failure'
  match "/log_out" => "sessions#destroy", :as => "log_out"
  match "/log_in" => "sessions#new", :as => "log_in"
  match "/sign_up" => "users#new", :as => "sign_up"
  root :to => "authentications#index"
  resources :users
  resources :sessions
  resources :authentications
end