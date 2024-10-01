require 'active_record'
require 'activerecord-import'

class UpdateCandlestickService
  INTERVAL_HASH = {
    day: "1d",
    week: "1w",
    month: "1M",
    hour: "1h",
    m15: '15m'
  }

  attr_accessor :merchandise_rate_ids, :interval

  def initialize merchandise_rate_ids, update_last_month = false
    @merchandise_rate_ids = merchandise_rate_ids
    @interval = '1M'
    @update_last_month = update_last_month
  end

  def execute
    update_data
  end

  def update_data
    ActiveRecord::Base.transaction do
      merchandise_rate_ids.each do |merchandise_rate_id|
        candlestick_records = []
        merchandise_rate = MerchandiseRate.find_by(id: merchandise_rate_id)
        return unless merchandise_rate.present?

        records = BinanceServices::Request.send!(
          path: "/api/v3/klines",
          params: {
            symbol: "#{merchandise_rate.slug.upcase}",
            interval: '1M',
          }
        )

        records = records.sort_by {|r| r[0]}.reverse.first(5) if @update_last_month

        records.each do |record|
          puts Time.at(record[0]/1000).to_datetime

          # next if merchandise_rate.candlesticks.where("Date(date) = ? AND time_type = ?", Time.at(record[0]/1000).to_date, interval.to_sym).count > 1
          candlestick = Candlestick.find_or_initialize_by(date: Time.at(record[0]/1000).to_datetime, merchandise_rate_id: merchandise_rate.id, time_type: 3)
          candlestick.attributes = {
            open: record[1],
            high: record[2],
            low: record[3],
            close: record[4],
            volumn: record[5]
          }
          candlestick.save!
        end
      end
    end
  end
end
