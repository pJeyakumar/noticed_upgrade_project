Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/mail" if Rails.env.development?
  resources :logbook_entries
  resources :users
  resources :aircrafts
end
