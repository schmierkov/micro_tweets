Rails.application.routes.draw do
  root 'overview#index'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :tweets, only: [:index]
    end
  end
end
