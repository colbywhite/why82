Rails.application.routes.draw do
  root 'home#index'
  get 'about', to: 'home#about'
  get 'teams/:season/tiers', to: 'teams#tiers'
  get 'games/:season/graded', to: 'games#graded'
  get 'graded', to: 'games#graded', defaults: { season: '2016' }
  post 'season/update',
       to: 'season#update',
       defaults: { format: 'json' }
end
