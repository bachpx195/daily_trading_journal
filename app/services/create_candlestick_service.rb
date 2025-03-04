require 'active_record'
require 'activerecord-import'

class CreateCandlestickService
  INTERVAL_HASH = {
    day: "1d",
    week: "1w",
    month: "1M",
    hour: "1h"
    # m15: '15m'
  }
  FIRST_DATE_IN_BINANCE = {
    BTC: 1502902800,
    LTC: 1513123200,
    BAT: 1551661260,
    DOT: 1597712400,
    NEO: 1511139600,
    ADA: 1523898000,
    XRP: 1525438500,
    # lay ket qua tu nam 2022
    LINK: 1642381200
  }

  ANALYTIC_INTERVAL = %('hour', 'day')

  MERCHANDISE_RATE_IDS = [
    34, # btc
    35, # ltc
    41, # ltc/btc
    37, # dot
    39, # dot/btc
    42, # link
    43  # link/btc
  ]

  attr_accessor :merchandise_rate_ids, :interval

  def initialize merchandise_rate_ids, interval
    @merchandise_rate_ids = merchandise_rate_ids
    @interval = interval
  end

  def execute
    time = 0
    status = false
    while true
      if (is_synchronous && is_lastest_date) || time > 5
        status = true
        break
      end
      create_data
      time = time + 1
    end

    {
      lastest_time: lastest_time,
      status: status
    }
  end

  def create_data
    merchandise_rate_ids.each do |merchandise_rate_id|
      candlestick_records = []
      merchandise_rate = MerchandiseRate.find_by(id: merchandise_rate_id)
      return unless merchandise_rate.present?

      # Tìm ngày cuối cùng ở database
      # Xoá dữ liệu cuối đi vì nó chưa đủ
      merchandise_rate.candlesticks.send(interval.to_sym).last.destroy if merchandise_rate.candlesticks.send(interval.to_sym).last.present?
      last_date = merchandise_rate.candlesticks.send(interval.to_sym).last

      last_time = if last_date.present?
        merchandise_rate.candlesticks.send(interval.to_sym).last.date.to_i + bonus_time
      else
        Time.at(FIRST_DATE_IN_BINANCE[merchandise_rate.base.slug.to_sym])
      end

      period = (Time.zone.now.to_datetime - Time.at(last_time).to_datetime).to_i

      period_loop = if interval == 'week'
        7000
      elsif interval == 'day'
        1000
      elsif interval == 'month'
        30000
      elsif interval == 'hour'
        1000/24
      elsif interval == 'm15'
        1000/(24*4)
      end
      ActiveRecord::Base.transaction do
        loop_number = period/period_loop
        (0..loop_number).each do |num|
          start_time = (Time.at(last_time).to_datetime + period_loop*num).to_datetime.to_i
          records = BinanceServices::Request.send!(
            path: "/api/v3/klines",
            params: {symbol: "#{merchandise_rate.slug.upcase}",
            interval: INTERVAL_HASH[interval.to_sym],
            startTime: "#{start_time}000", limit: "1000"}
          )
          records.each do |record|
            # next if merchandise_rate.candlesticks.where("Date(date) = ? AND time_type = ?", Time.at(record[0]/1000).to_date, interval.to_sym).count > 1
            candlestick_records.push({
              date: Time.at(record[0]/1000).to_datetime,
              open: record[1],
              high: record[2],
              low: record[3],
              close: record[4],
              volumn: record[5],
              time_type: interval.to_sym,
              merchandise_rate_id: merchandise_rate.id
            })
          end
        end
        Candlestick.import(candlestick_records, validate: false)
        Candlestick.delete_duplicate
      end

      if HourAnalytic.list_merchandise_rate_id.map{|x| x}.flatten.include?(merchandise_rate_id) &&
        ANALYTIC_INTERVAL.include?(interval)
        puts "______________LAST TIME______________"
        puts "#{merchandise_rate_id} #{Time.at(last_time).to_date}"
        HourAnalytic.create_hour_data Time.at(last_time).to_date, merchandise_rate_id
        # UpdateHourAnalyticService.new(merchandise_rate_id, Time.at(last_time).to_date.strftime("%Y-%m-%d")).execute
        DayAnalytic.create_day_data Time.at(last_time).to_date, merchandise_rate_id
        # UpdateDayAnalyticService.new([merchandise_rate_id], Time.at(last_time).to_date.strftime("%Y-%m-%d")).execute
      end
    end
  end

  def create_month_data
    MERCHANDISE_RATE_IDS.each do |merchandise_rate_id|
      candlestick_records = []
      merchandise_rate = MerchandiseRate.find_by(id: merchandise_rate_id)
      return unless merchandise_rate.present?

      last_time = Time.at(FIRST_DATE_IN_BINANCE[merchandise_rate.base.slug.to_sym])

      period = (Time.zone.now.to_datetime - Time.at(last_time).to_datetime).to_i

      period_loop = 30000

      ActiveRecord::Base.transaction do
        loop_number = period/period_loop
        (0..loop_number).each do |num|
          start_time = (Time.at(last_time).to_datetime + period_loop*num).to_datetime.to_i
          records = BinanceServices::Request.send!(
            path: "/api/v3/klines",
            params: {symbol: "#{merchandise_rate.slug.upcase}",
            interval: "1M",
            startTime: "#{start_time}000", limit: "1000"}
          )
          records.each do |record|
            next if merchandise_rate.candlesticks.where("Date(date) = ? AND time_type = ?", Time.at(record[0]/1000).to_date, 3).count > 1
            candlestick_records.push({
              date: Time.at(record[0]/1000).to_datetime,
              open: record[1],
              high: record[2],
              low: record[3],
              close: record[4],
              volumn: record[5],
              time_type: 3,
              merchandise_rate_id: merchandise_rate.id
            })
          end
        end
        Candlestick.import(candlestick_records, validate: false)
        Candlestick.delete_duplicate
      end
    end
  end

  class << self
    def update_day_data mr_ids
      mr_ids.each do |merchandise_rate_id|
        candlestick_records = []
        merchandise_rate = MerchandiseRate.find_by(id: merchandise_rate_id)
        return unless merchandise_rate.present?

        last_time = Time.at(FIRST_DATE_IN_BINANCE[merchandise_rate.base.slug.to_sym])

        period = (Time.zone.now.to_datetime - Time.at(last_time).to_datetime).to_i

        period_loop = 30000

        ActiveRecord::Base.transaction do
          loop_number = period/period_loop
          (0..loop_number).each do |num|
            start_time = (Time.at(last_time).to_datetime + period_loop*num).to_datetime.to_i
            records = BinanceServices::Request.send!(
              path: "/api/v3/klines",
              params: {symbol: "#{merchandise_rate.slug.upcase}",
              interval: "1d",
              startTime: "#{start_time}000", limit: "1000"}
            )
            records.each do |record|
              next if merchandise_rate.candlesticks.where("Date(date) = ? AND time_type = ?", Time.at(record[0]/1000).to_date, 3).count > 1
              candlestick_records.push({
                date: Time.at(record[0]/1000).to_datetime,
                open: record[1],
                high: record[2],
                low: record[3],
                close: record[4],
                volumn: record[5],
                time_type: 3,
                merchandise_rate_id: merchandise_rate.id
              })
            end
          end
          Candlestick.import(candlestick_records, validate: false)
          Candlestick.delete_duplicate
        end
      end
    end
  end

  private
  # Thời gian của các merchandise là giống nhau
  def is_synchronous
    return true if merchandise_rate_ids.count == 1
    lastest_date_list = []

    merchandise_rate_ids.each do |merchandise_rate_id|
      merchandise_rate = MerchandiseRate.find_by(id: merchandise_rate_id)
      lastest_date_list.push(merchandise_rate.lastest_candlestick_date(interval))
    end

    # check if all array elements are equal
    lastest_date_list.uniq.size <= 1
  end

  def is_lastest_date
    lastest_time >= (Time.now() - bonus_time)
  end

  def lastest_time
    merchandise_rate = MerchandiseRate.find_by(id: merchandise_rate_ids.first)
    merchandise_rate.lastest_candlestick_date(interval)
  end

  # thời gian thêm dựa vào interval
  def bonus_time
    interval == 'm15' ? 15.minutes : 1.send(interval.to_sym)
  end
end
