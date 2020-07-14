Rails.application.routes.draw do


  # из модели Юзер-Акции нам нужно тольеко метод Create ? остальные отключаем
  resources :user_stocks, only: [:create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  get 'my_portfolio', to: 'users#my_portfolio'
  get 'search_stock', to: 'stocks#search'

  devise_for :users
end
