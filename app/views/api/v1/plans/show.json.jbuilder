json.array!(@plans) do |plan|
  json.id plan.id
  json.text plan.title.present? ? plan.title : "Cây phân cấp"
  json.parent plan.parent_id ? plan.parent_id.to_s : "#"
  json.state do
    json.opened true
  end
end