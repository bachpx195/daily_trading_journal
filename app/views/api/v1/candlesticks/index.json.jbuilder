my_array = @candlesticks.map do |c|
  [c.date.to_i, c.open, c.high, c.low, c.close, c.volumn]
end

json.ohlcv my_array
