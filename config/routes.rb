Rails.application.routes.draw do
  root 'home#index'
  get 'games', to: 'games#index', defaults: { format: 'json' }
  get 'teams', to: 'teams#index'
  get 'games/:season/graded', to: 'games#graded'
  post 'season/update',
       to: 'season#update',
       defaults: { format: 'json' }
end
