json.extract! fund_log, :id, :change_amount, :change_type, :created_at, :updated_at
json.url fund_log_url(fund_log, format: :json)
