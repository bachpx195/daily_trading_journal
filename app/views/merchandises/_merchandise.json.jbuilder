json.extract! merchandise, :id, :name, :slug, :base, :quote, :winrate, :desciption, :is_follow, :tag_id, :created_at, :updated_at
json.url merchandise_url(merchandise, format: :json)
