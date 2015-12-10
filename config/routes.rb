Rails.application.routes.draw do
  root 'home#index'
  get 'about', to: 'home#about'
  get 'games/:season/info', to: 'games#info'
  post 'season/update',
       to: 'season#update',
       defaults: { format: 'json' }
end
