Rails.application.routes.draw do
  devise_for :users

  root "logbook_entries#index"

  mount LetterOpenerWeb::Engine, at: "/mail" if Rails.env.development?

  resources :logbook_entries
  resources :users
  resources :aircrafts
end
