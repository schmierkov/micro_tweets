Rails.application.routes.draw do
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
