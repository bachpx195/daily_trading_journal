namespace :db do
  desc "remake candlestick data"
  desc "bundle exec rake db:import_candlestick_data bach=test"

  task import_candlestick_data: :environment do
    FIRST_DATE_IN_BINANCE = 1502902800
    desc "remake candlestick data"
    base = ENV['base']
    quote = ENV['quote']

    abort("Errors: vui long nhap base=xxx quote=xxx") if !base.present? or !quote.present?

    base_merchandise = Merchandise.find_by(slug: base)
    quote_merchandise = Merchandise.find_by(slug: quote)

    abort("Errors: khong tim thay #{base}") unless base_merchandise.present?
    abort("Errors: khong tim thay #{quote}") unless quote_merchandise.present?

    merchandise_rate = MerchandiseRate.find_by(base_id: base_merchandise.id, quote_id: quote_merchandise)
    abort("Errors: khong tim thay MerchandiseRate") unless merchandise_rate.present?

    ActiveRecord::Base.transaction do
      period = (Time.zone.now.to_date - Time.at(FIRST_DATE_IN_BINANCE).to_date).to_i
      merchandise_rate.candlesticks.destroy_all
      loop_number = (period/1000)
      (0..loop_number).each_with_index do |num, index|
        puts index
        start_time = (Time.at(1502902800).to_date + 1000*num).to_time.to_i
        puts start_time
        puts "=========================================================================="
        puts Time.at(start_time).to_date
        records = BinanceServices::Request.send!(path: "/api/v3/klines", params: {symbol: "#{merchandise_rate.slug.upcase}", interval: "1d", startTime: "#{start_time}000", limit: "1000"})
        puts records[0]
        records.each_with_index do |record, idx|
          puts Time.at(record[0]/1000).to_date
          next if Candlestick.where("Date(date) = ?", Time.at(record[0]/1000).to_date).count > 1
          merchandise_rate.candlesticks.create!(date: Time.at(record[0]/1000).to_datetime, open: record[1], high: record[2], low: record[3], close: record[4], volumn: record[5], time_type: :day)
        end
      end
    end
  end
end
