namespace :db do
  desc "remake candlestick data"

  task import_candlestick_data: :environment do
    records = BinanceServices::Request.send!(oath: "/api/v3/klines", params: {symbol: "BTCUSDT", interval: "1d"})
    @merchandise_rate.candlesticks.create!(date: Time.at(record[0]/1000).to_datetime, open: record[1], high: record[2], low: record[3], close: record[4], volumn: record[5])                        
  end
end