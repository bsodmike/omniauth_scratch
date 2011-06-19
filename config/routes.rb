Auth::Application.routes.draw do
  get "sessions/new"

  get "sign_up" => "users#new", :as => "sign_up"
  root :to => "users#new"
  
  resources :users
end