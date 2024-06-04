Rails.application.routes.draw do
  resources :logbook_entries
  resources :users
  resources :aircrafts
end
