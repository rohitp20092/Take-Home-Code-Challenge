Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      resources :transactions, only: [] do
        collection do
          post :single, to: 'transactions#create'
        end
      end
    end
  end
end
