datetime_id_mapping = {}

candlesticks_array = @candlesticks.map do |c|
  date_integer = c.date.to_i*1000
  datetime_id_mapping[date_integer] = c.id
  [date_integer, c.open, c.high, c.low, c.close, c.volumn]
end

candlesticks_future_array = @candlesticks_future.map do |c|
  date_integer = c.date.to_i*1000
  datetime_id_mapping[date_integer] = c.id if !datetime_id_mapping[:date_integer].present?
  [date_integer, c.open, c.high, c.low, c.close, c.volumn]
end

json.ohlcv candlesticks_array
json.future_ohlcv candlesticks_future_array
json.datetime_id_mapping datetime_id_mapping
