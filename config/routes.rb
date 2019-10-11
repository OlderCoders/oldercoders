Rails.application.routes.draw do

  scope '/account' do
    devise_for :accounts,
      path: '/',
      path_names: {
        sign_in: 'login',
        sign_out: 'logout',
        sign_up: 'new'
      }
    scope module: :accounts do
      resource :username, only: %i[new update], path_names: { edit: "/" }
    end
  end

  scope '/:username' do
    resource :account, only: %i[show edit update destroy], path: '/'

    scope module: :accounts do
      resource :profile, only: %i[edit update], path_names: { edit: "/" }
      resource :relationship, only: %i[create destroy]
    end
  end

  root to: 'home#index'
end
