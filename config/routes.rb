Rails.application.routes.draw do

  mount LetterOpenerWeb::Engine, at: "/mails" if Rails.env.development?

  root 'logbook_entries#index'
  resources :logbook_entries
  resources :users
  resources :aircrafts
end
