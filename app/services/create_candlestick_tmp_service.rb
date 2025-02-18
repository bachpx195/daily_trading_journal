require 'active_record'
require 'activerecord-import'

class CreateCandlestickTmpService
  INTERVAL_HASH = {
    day: "1d",
    week: "1w",
    month: "1M",
    hour: "1h"
    # m15: '15m'
  }
  FIRST_DATE_IN_BINANCE = {
    LINK: 1548982800
  }

  ANALYTIC_INTERVAL = %('hour', 'day')

  attr_accessor :merchandise_rate_ids, :interval

  def initialize interval
    @merchandise_rate_ids = [42, 43]
    @interval = interval
  end

  def execute
    time = 0
    status = false
    while true
      if time > 5
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
      return if merchandise_rate.candlesticks.send(interval.to_sym).order(date: :asc).first.date.year == 2019

      last_time = Time.at(FIRST_DATE_IN_BINANCE[merchandise_rate.base.slug.to_sym])

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
            puts Time.at(record[0]/1000).to_date
            break if Time.at(record[0]/1000).to_date > '2022-01-19'.to_date
            
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

      # if HourAnalytic.list_merchandise_rate_id.map{|x| x}.flatten.include?(merchandise_rate_id) &&
      #   ANALYTIC_INTERVAL.include?(interval)
      #   puts "______________LAST TIME______________"
      #   puts "#{merchandise_rate_id} #{Time.at(last_time).to_date}"
      #   HourAnalytic.create_hour_data Time.at(last_time).to_date, merchandise_rate_id
      #   UpdateHourAnalyticService.new(merchandise_rate_id, Time.at(last_time).to_date.strftime("%Y-%m-%d"))
      #   DayAnalytic.create_day_data Time.at(last_time).to_date, merchandise_rate_id
      #   UpdateDayAnalyticService.new([merchandise_rate_id], Time.at(last_time).to_date.strftime("%Y-%m-%d")).execute
      # end
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
