Rails.application.routes.draw do

  devise_for :accounts,
             path: 'account',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               sign_up: 'new'
             }

  root 'sessions#new', format: 'html'

  scope '/account' do
    scope module: :accounts do
      resource :username, only: %i[new update]
    end
  end

  scope '/:username' do
    resource :account, only: %i[show edit update destroy], path: '/'

    scope module: :accounts do
      resource :profile, only: %i[edit update]
      resource :relationship, only: %i[create destroy]
    end
  end
end
