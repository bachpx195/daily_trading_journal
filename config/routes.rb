Rails.application.routes.draw do
  resources :logs
  resources :trades
  resources :trade_normal_methods
  resources :trade_pyramid_methods
  resources :trade_methods
  resources :funds
  mount Ckeditor::Engine => '/ckeditor'
  resources :wikis
  resources :groups
  resources :daily_reports
  resources :news_sites
  resources :news
  resources :coin_links
  resources :coin_sources
  resources :coins
  resources :tags
  get 'dashboard/index'
  root "dashboard#index"
  resources :calculates

  get "/pages/*page", to: "pages#show"
end
