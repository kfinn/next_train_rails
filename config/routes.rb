Rails.application.routes.draw do
  resources :departures, only: :index
end
