candlesticks_array = @candlesticks.map do |c|
  [c.date.to_i*1000, c.open, c.high, c.low, c.close, c.volumn]
end

candlesticks_future_array = @candlesticks_future.map do |c|
  [c.date.to_i*1000, c.open, c.high, c.low, c.close, c.volumn]
end

json.ohlcv candlesticks_array
json.future_ohlcv candlesticks_future_array
