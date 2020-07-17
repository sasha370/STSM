Rails.application.routes.draw do

  # из модели Юзер-Акции нам нужно тольеко метод Create и дестрой остальные отключаем
  resources :user_stocks, only: [:create, :destroy]

  # Добавить в друзья и удалить реализовано через Friendship
  # После генерации удалил Вьюхи и GETs которые прописались автоматом
  resources :friendships, only: [:create, :destroy]
  resources :users, only: [:show], :constraints => { :id => /[0-9|]+/ }

  root 'welcome#index'
  get 'my_portfolio', to: 'users#my_portfolio'
  get 'search_stock', to: 'stocks#search'
  get 'my_friends', to: 'users#my_friends'

  # Поиск реализован через контроллер USER
  get 'search_friend', to: 'users#search'


  devise_for :users
end
