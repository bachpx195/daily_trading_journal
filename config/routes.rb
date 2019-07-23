Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  root "dashboard#index"

  devise_for :users
  resources :fund_logs
  resources :logs
  resources :trades do
    member do
      get 'close', to: 'trades#close'
    end
  end
  resources :trade_normal_methods
  resources :trade_pyramid_methods
  resources :trade_methods
  resources :funds
  resources :wikis
  resources :daily_reports
  resources :news_sites
  resources :news
  resources :coin_links
  resources :coin_sources
  resources :coins
  resources :tags
  resources :calculates

  get "/pages/*page", to: "pages#show"

  namespace :api do
    namespace :v1 do
      resources :tags
    end
  end
end
