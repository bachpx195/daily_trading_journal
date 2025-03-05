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

  resources :date_events do
    collection do
      get 'event_masters', to: 'date_events#event_masters'
    end
  end
  resources :event_masters do
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
      resources :charts do
        collection do
          get 'effect_hour_candlestick_type_in_day', to: 'charts#effect_hour_candlestick_type_in_day'
          get 'highest_return_hour_in_day', to: 'charts#highest_return_hour_in_day'
        end
      end
      resources :tags
      resources :plans
      resources :news
      resources :merchandise_rates, only: [:index], defaults: { format: 'json' }
      resources :candlesticks, only: [:index], defaults: { format: 'json' } do
        member do
          get 'info', to: 'candlesticks#info'
        end
        collection do
          post 'async_update_data', to: 'candlesticks#async_update_data'
          get 'merchandise_rates', to: 'candlesticks#merchandise_rates'
          get 'monthly_return', to: 'candlesticks#monthly_return'
        end
      end
      resources :day_analytics, only: [:create], defaults: { format: 'json' } do
        collection do
          post 'update_hour_analytic', to: 'day_analytics#update_hour_analytic'
          get 'last_updated_date', to: 'day_analytics#last_updated_date'
          get 'merchandise_rates', to: 'day_analytics#merchandise_rates'
          post 'update_continuous', to: 'day_analytics#update_continuous'
        end
      end
      resources :hour_analytics, only: [:index], defaults: { format: 'json' } do
        collection do
          post 'update_continuous', to: 'hour_analytics#update_continuous'
        end
      end
      resources :data_validations, only: [:show], defaults: { format: 'json' } do
        collection do
          get 'day_analytics', to: "data_validations#day_analytics"
        end
      end
      resources :telegram_chat_messages, only: [:create]
      resources :event_dates, only: [:index] do
        collection do
          get 'list_event', to: 'event_dates#list_event'
        end
      end
    end
  end
end
