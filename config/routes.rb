Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    # api routes 
  namespace :api, defaults: { format: :json } do
    namespace :v1 do

      resources :users do
      	collection do
      		post :signup
      	end
      end

    end
  end
  
end
