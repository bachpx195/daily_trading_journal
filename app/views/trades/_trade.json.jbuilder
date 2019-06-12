json.extract! trade, :id, :coin_id, :status, :start_date, :end_date, :reason, :created_at, :updated_at
json.url trade_url(trade, format: :json)
