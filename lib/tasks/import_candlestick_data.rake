namespace :db do
  desc "remake candlestick data"
  desc "bundle exec rake db:import_candlestick_data bach=test interval=1w"


  task import_candlestick_data: :environment do
    desc "remake candlestick data"
    base = ENV['base']
    quote = ENV['quote']
    interval = ENV['interval']

    interval_hash = {
      day: "1d",
      week: "1w",
      month: "1M",
      hour: "1h"
    }
    FIRST_DATE_IN_BINANCE = {
      BTC: 1502902800,
      LTC: 1513123200,
      BAT: 1551661260
    }

    abort("Errors: vui long nhap base=xxx quote=xxx interval=x --- ex (x = day, week)") if !base.present? || !quote.present? || !interval.present?

    abort("Errors: interval khong hop le --- (day, week)") unless ['day', 'week', 'month', 'hour'].include? interval

    base_merchandise = Merchandise.find_by(slug: base)
    quote_merchandise = Merchandise.find_by(slug: quote)

    abort("Errors: khong tim thay #{base}") unless base_merchandise.present?
    abort("Errors: khong tim thay #{quote}") unless quote_merchandise.present?

    merchandise_rate = MerchandiseRate.find_by(base_id: base_merchandise.id, quote_id: quote_merchandise)
    abort("Errors: khong tim thay MerchandiseRate") unless merchandise_rate.present?

    ActiveRecord::Base.transaction do
      if interval != "hour"
        merchandise_rate.candlesticks.send(interval.to_sym).destroy_all
        last_time = Time.at(FIRST_DATE_IN_BINANCE[base.to_sym])
      else
        merchandise_rate.candlesticks.last
        last_date = merchandise_rate.candlesticks.send(interval.to_sym).last

        last_time = if last_date.present?
          merchandise_rate.candlesticks.send(interval.to_sym).last.date.to_i
        else
          Time.at(FIRST_DATE_IN_BINANCE[base.to_sym])
        end
      end

      period = (Time.zone.now.to_date - Time.at(last_time).to_date).to_i


      period_loop = if interval == 'week'
        7000
      elsif interval == 'day'
        1000
      elsif interval == 'month'
        30000
      elsif interval == 'hour'
        1000/24
      end

      loop_number = period/period_loop
      (0..loop_number).each_with_index do |num, index|
        start_time = (Time.at(last_time).to_date + period_loop*num).to_time.to_i
        puts start_time
        puts "=========================================================================="
        puts Time.at(start_time).to_date
        records = BinanceServices::Request.send!(path: "/api/v3/klines", params: {symbol: "#{merchandise_rate.slug.upcase}", interval: interval_hash[interval.to_sym], startTime: "#{start_time}000", limit: "1000"})
        abort("Errors: #{records}") if records.kind_of?(Hash)
        records.each_with_index do |record, idx|
          puts Time.at(record[0]/1000).to_date
          next if merchandise_rate.candlesticks.where("Date(date) = ? AND time_type = ?", Time.at(record[0]/1000).to_date, interval.to_sym).count > 1
          merchandise_rate.candlesticks.create!(date: Time.at(record[0]/1000).to_datetime, open: record[1], high: record[2], low: record[3], close: record[4], volumn: record[5], time_type: interval.to_sym)
        end
      end
      Candlestick.delete_duplicate
    end
  end
end
