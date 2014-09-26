Rails.application.routes.draw do
  resources :reports

  root to: 'visitors#index'
  devise_for :users
  resources :users
  get '/oauth2callback' => 'reports#outh_response', as: 'reports_outh_path'
end
