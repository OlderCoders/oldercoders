Rails.application.routes.draw do

  scope '/:username' do
    resource :user, only: %i[show edit update destroy], path: '/'
  end
end
