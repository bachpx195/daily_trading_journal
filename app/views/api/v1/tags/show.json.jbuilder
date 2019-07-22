json.array!(@tags) do |tag|
  json.id tag.id
  json.text tag.slug
  json.parent tag.parent_id ? tag.parent_id.to_s : "#"
  json.state do
    json.opened true
  end
end