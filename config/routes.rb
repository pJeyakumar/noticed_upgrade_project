Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root "logbook_entries#index"

  mount LetterOpenerWeb::Engine, at: "/mail" if Rails.env.development?

  resources :logbook_entries
  resources :users
  resources :aircrafts
  resources :notifications, only: %i[index], shallow: true do
    patch :toggle_read, on: :member
  end
end
