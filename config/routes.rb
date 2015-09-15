Rails.application.routes.draw do
  root 'home#index'
  get 'games', to: 'games#index', defaults: { format: 'json' }
  get 'teams', to: 'teams#index'
end
