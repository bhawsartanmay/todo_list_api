Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    # api routes 
    devise_for :users
  namespace :api, defaults: { format: :json } do
    namespace :v1 do

      resources :users do
      	collection do
      		post :sign_up
      	end
      end
      resources :todo_lists do
      	resources :todo_items
      end
    end
  end
  
end
