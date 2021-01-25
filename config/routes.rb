Rails.application.routes.draw do
  resources :system_configs
  resources :currency_pairs do
    member do
      get 'candlesticks', to: "candlesticks#index"
      post 'candlesticks', to: "candlesticks#create"
    end
  end
  resources :symbolfxes
  mount Ckeditor::Engine => '/ckeditor'

  root "dashboard#index"
  get "/pages/*page", to: "dashboard#show"

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
  resources :news do
    collection do
      get 'canlendar', to: 'news#canlendar'
    end
  end
  resources :coin_links
  resources :coin_sources
  resources :coins
  resources :tags
  resources :plans
  resources :calculates
  resources :glossaries
  resources :comments

  namespace :api do
    namespace :v1 do
      resources :tags
      resources :plans
      resources :news
    end
  end
end
