Rails.application.routes.draw do
    devise_for :users,
               path: '',
               path_names: {
                   sign_in: 'login',
                   sign_out: 'logout',
                   registration: 'signup',
                   invitation: 'invitation'
               },
               controllers: {
                   sessions: 'sessions',
                   registrations: 'registrations',
                   invitations: 'invitations'
               }
    namespace :api do
	    namespace :v1 do
	        resources :thing, only: [:index, :show, :create, :update, :destroy]
            post '/thing/activate', to: 'thing#activate'

            resources :cluster, only: [:index]
            get '/cluster/things/:cluster_group_id', to: 'cluster#things'

            resources :family, only: [:index, :create]
            get '/family/clusters/:family_group_id', to: 'family#clusters'
	    end
    end

    get '/ping', to: 'ping#index'
    get '/ping-auth', to: 'ping_auth#index'
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
