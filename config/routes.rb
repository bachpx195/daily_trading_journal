Rails.application.routes.draw do
  resources :b_orders
  resources :rules
  resources :ideas
  resources :merchandises
  devise_for :users

  resources :blogs
  resources :system_configs
  resources :merchandise_rates do
    member do
      get 'candlesticks', to: "candlesticks#index"
      post 'candlesticks', to: "candlesticks#create"
    end
  end
  mount Ckeditor::Engine => '/ckeditor'

  root "blog/blogs#index"
  get '/blog/:id', to: 'blog/blogs#show'


  get "dashboard", to: "dashboard#index"
  get "/pages/*page", to: "dashboard#show"

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
      resources :merchandise_rates, defaults: { format: 'json' }
      resources :candlesticks, defaults: { format: 'json' } do
        collection do
          post 'async_update_data', to: 'candlesticks#async_update_data'
        end
      end
    end
  end
end
