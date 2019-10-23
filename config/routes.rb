Rails.application.routes.draw do

  scope '/account' do
    get '/', to: redirect('/')

    devise_for :accounts,
      path: '/',
      path_names: {
        sign_in: 'login',
        sign_out: 'logout',
        sign_up: 'new'
      }
    scope module: :accounts do
      resource :username, only: %i[new update], path_names: { edit: '/' }
      resource :profile, only: %i[edit update], path_names: { edit: '/' }
    end
  end

  scope '/posts' do
    resources :posts, controller: 'entries', type: 'Post', param: :slug, path: '/'
  end

  scope '/:username' do
    resource :account, only: %i[show edit update destroy], path: '/'

    scope module: :accounts do
      resource :relationship, only: %i[create destroy]
      get 'following', to: 'relationships#following'
      get 'followers', to: 'relationships#followers'
    end
  end

  root to: 'home#index'
end
