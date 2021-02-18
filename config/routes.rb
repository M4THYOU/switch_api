Rails.application.routes.draw do
    devise_for :users,
               path: '',
               path_names: {
                   sign_in: 'login',
                   sign_out: 'logout',
                   registration: 'signup'
               },
               controllers: {
                   sessions: 'sessions',
                   registrations: 'registrations'
               }
    namespace :api do
	    namespace :v1 do
	        resources :thing, only: [:index, :show, :create, :update]

            resources :cluster, only: [:index]

            resources :family, only: [:index, :create]
            get '/family/clusters/:family_group_id', to: 'family#clusters'
	    end
    end

    get '/ping', to: 'ping#index'
    get '/ping-auth', to: 'ping_auth#index'
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
