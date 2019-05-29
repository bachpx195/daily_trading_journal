json.extract! coin, :id, :slug, :title, :description, :code, :rank, :market_cap_usd, :price_usd, :tag_id, :created_at, :updated_at
json.url coin_url(coin, format: :json)
