Rails.application.routes.draw do
  resources :questions do
    resources :answers
  end

  root to: "questions#index"
end
