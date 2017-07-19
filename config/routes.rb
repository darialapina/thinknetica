Rails.application.routes.draw do

  resources :comments, only: [:create]

  resources :votes, only: [:create] do
    delete :reset, on: :collection
  end

  delete 'attachments/:id' => 'attachments#destroy'

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    post '/register' => 'omniauth_callbacks#register'
  end

  resources :questions do
    resources :answers, shallow: true do
      patch :set_best, on: :member
    end
  end

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
