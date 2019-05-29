json.extract! coin_link, :id, :url, :kind, :coin, :created_at, :updated_at
json.url coin_link_url(coin_link, format: :json)
