Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resource :user, only: %i{ create } 

      resource :session, only: %i{ create }
    end
  end

end
