json.extract! news, :id, :url, :domain, :short_description, :title, :published_at, :status, :intended_date, :tag, :created_at, :updated_at
json.url news_url(news, format: :json)
