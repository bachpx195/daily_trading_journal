json.extract! coin_source, :id, :title, :domain_slug, :website, :coin, :created_at, :updated_at
json.url coin_source_url(coin_source, format: :json)
