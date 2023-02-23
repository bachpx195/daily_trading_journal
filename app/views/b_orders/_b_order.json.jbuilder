json.extract! b_order, :id, :b_order_id, :merchandise_rate_id, :client_order, :price, :orig_qty, :executed_qty, :executed_quote_qty, :status, :type, :side, :insert_time, :update_time, :delegate_money, :avg_price, :orig_type, :position_side, :created_at, :updated_at
json.url b_order_url(b_order, format: :json)
