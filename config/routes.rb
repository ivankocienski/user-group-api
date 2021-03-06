Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resource :user, only: %i{ create show } 

      resource :session, only: %i{ create update }

      resources :groups, only: %i{ create } do
        resources :users, only: %i{ create }, controller: 'group_users'
      end
    end
  end

end
