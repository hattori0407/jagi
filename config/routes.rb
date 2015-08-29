Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

  resource :user_profile, only: [:show, :edit, :update]
  resource :quiz, only: [:new, :create, :destroy] do
    get  :question, on: :member
    post :answer,   on: :member
    get  :result,   on: :member
  end

  root to: 'home#welcome'
end
