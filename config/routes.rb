Rails.application.routes.draw do
  root 'home#index'
  get 'games', to: 'games#index', defaults: { format: 'json' }
  get 'teams', to: 'teams#index'
  get 'teams/:season/tiers', to: 'teams#tiers'
  get 'games/:season/graded', to: 'games#graded'
  get 'graded', to: 'games#graded', defaults: { season: '2016' }
  post 'season/update',
       to: 'season#update',
       defaults: { format: 'json' }
end
