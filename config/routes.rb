Rails.application.routes.draw do

  root to = 'homes#top'
  devise_for :users

  resources :chats, only: [:show, :create]
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  # groupのルーティング（destroy以外のアクションを実行する）
  resources :groups do
    get"join" => "groups#join"
  end
  
  #ゲストユーザーに関する記述
  devise_scope:user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "home/about"=>"homes#about", as: 'about'
  get 'search' => "searches#search"
  #メールに関する記述
  get "join" => "groups#join"
  get "new/mail" => "groups#new_mail"
  get "send/mail" => "groups#send_mail"
end