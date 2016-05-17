Rails.application.routes.draw do
  root 'overview#index'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :tweets, only: [] do
        collection do
          get ':keyword', action: :index
        end
      end
    end
  end
end
