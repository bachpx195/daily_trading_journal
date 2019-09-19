json.array!(@news) do |new|
  json.extract! new, :id, :title, :description
  json.start new.start_date
  json.end new.end_date
  json.url new_url(new, format: :html)
end