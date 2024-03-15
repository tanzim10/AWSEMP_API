Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post '/login', to: 'session#create'
  delete '/logout', to: 'session#destroy'
  post '/signup', to: 'registration#create'
  namespace :api do
    namespace :v1 do
      resources :employees, only: [:index, :show, :create, :update, :destroy]
      get '/all_emp', to: 'employees#index' 
      get '/emp/:id', to: 'employees#show'
      delete '/destroy_emp/:id', to: 'employees#destroy'
      post '/create_emp', to: 'employees#create'
      patch '/update_emp/:id', to: 'employees#update'

      
    end
  end
end
