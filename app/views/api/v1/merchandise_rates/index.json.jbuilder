json.array!(@merchandise_rates) do |mr|
  json.id mr.id
  json.slug mr.slug
  json.base_id
  json.quote_id
end
