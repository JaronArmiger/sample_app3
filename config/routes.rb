Rails.application.routes.draw do
  root 'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users do
    # this makes /users/:id/following and
    # /users/:id/followers available

    # URL:          /users/1/following
    # action:       following
    # named route:  following_user_path(1)
    member do
      get :following, :followers
    end

    # if I used "collection do"
    # then I could access /users/followers
    # (no :id)
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end
