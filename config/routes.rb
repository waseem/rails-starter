Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index', constraints: lambda { |request| request.session['auth_token'] }
  root to: 'user_sessions#new'

  get  'sign_up'  => 'users#new',             as: 'sign_up'
  post 'sign_up'  => 'users#create',          as: ''

  get  'sign_in'  => 'user_sessions#new',     as: 'sign_in'
  post 'sign_in'  => 'user_sessions#create',  as: ''

  match 'sign_out' => 'user_sessions#destroy', as: 'sign_out', via: [:get, :post, :delete]

  get   'password_reset'      => 'password_resets#new',   as: :new_password_reset
  get   'password_resets/:id' => 'password_resets#edit',  as: :edit_password_reset
  patch 'password_resets/:id' => 'password_resets#update'
  put   'password_resets/:id' => 'password_resets#update'
  post  'password_resets'     => 'password_resets#create'

  resource :user
  resource :confirmation, only: :new
end
