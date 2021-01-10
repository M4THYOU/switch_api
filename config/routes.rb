Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'thing/index'
      get 'thing/show'
      get 'thing/update'
    end
  end
  namespace :api do
    namespace :v1 do
      get 'switch/index'
      get 'switch/show'
      get 'switch/update'
    end
  end
  namespace :api do
    namespace :v1 do
      resources :thing, only: [:index, :show, :update]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
