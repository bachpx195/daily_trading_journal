namespace :db do
  desc "remake candlestick data"
  desc "bundle exec rake db:import_candlestick_data bach=test"

  task import_candlestick_data: :environment do
    FIRST_DATE_IN_BINANCE = 1502902800
    desc "remake candlestick data"
    base = ENV['base']
    quote = ENV['q']

    ActiveRecord::Base.transaction do
      merchandise_rate = MerchandiseRate.last
      period = (Time.zone.now.to_date - Time.at(FIRST_DATE_IN_BINANCE).to_date).to_i
      merchandise_rate.candlesticks.destroy_all
      loop_number = (period/1000)
      (0..loop_number).each_with_index do |num, index|
        puts index
        start_time = (Time.at(1502902800).to_date + 1000*num).to_time.to_i
        puts start_time
        puts "=========================================================================="
        puts Time.at(start_time).to_date
        records = BinanceServices::Request.send!(path: "/api/v3/klines", params: {symbol: "BTCUSDT", interval: "1d", startTime: "#{start_time}000", limit: "1000"})
        records.each_with_index do |record, idx|
          puts Time.at(record[0]/1000).to_date
          next if Candlestick.where("Date(date) = ?", Time.at(record[0]/1000).to_date).count > 1
          merchandise_rate.candlesticks.create!(date: Time.at(record[0]/1000).to_datetime, open: record[1], high: record[2], low: record[3], close: record[4], volumn: record[5])
        end
      end
    end
  end
end
