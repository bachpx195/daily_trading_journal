Rails.application.routes.draw do
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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
