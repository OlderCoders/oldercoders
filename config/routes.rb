Rails.application.routes.draw do

  root 'user#show', format: 'html'

  # Login/Logout
  get    'login',  to: 'sessions#new'
  post   'login',  to: 'sessions#create'
  get    'logout', to: 'sessions#destroy'
  delete 'logout', to: 'sessions#destroy'

  # New Accounts
  get    'signup',         to: 'accounts#new'
  post   'account/create', to: 'accounts#create', as: 'create_user_account'

  # Account Activation
  get    'activate/:id',          to: 'account_activations#edit',   as: 'account_activation'
  get    'activation/resend/:id', to: 'account_activations#resend', as: 'resend_account_activation'

  scope '/:username' do
    resource :user, only: %i[show edit update destroy], path: '/'
  end
end
