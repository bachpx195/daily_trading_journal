require 'active_record'
require 'activerecord-import'

class Candlestick < ApplicationRecord
  belongs_to :merchandise_rate
  enum time_type: {day: 1, week: 2, month: 3, hour: 4, m15: 5}

  # date_between( "2022-05-10","2022-05-12")
  scope :date_between, -> start_date, end_date do
    where("date >= ? AND date <= ?", start_date.to_date.beginning_of_day, end_date.to_date.end_of_day )
  end

  scope :time_between, -> start_time, end_time do
    where("date >= ? AND date <= ?", start_time, end_time )
  end

  scope :find_by_merchandise_rate, -> merchandise_rate_id, time_type, limit do
    where(merchandise_rate_id: merchandise_rate_id)
    .where(time_type: time_type)
    .limit(limit)
    .order(date: :desc)
  end

  # :desc, :asc
  scope :sort_by_type, -> sort_type do
    order(date: sort_type)
  end

  class << self
    def delete_duplicate
      Candlestick.where.not(id: Candlestick.group(:date, :time_type, :merchandise_rate_id).select("min(id)")).destroy_all
    end

    # Mục đích là tìm 100 giá trị trước và sau date được chọn
    def range_between_date date, type, limit
      case type
      when time_types["day"]
        [date - 100.days, date + limit.days, date + 1.days]
      when time_types["week"]
        [date - 100.weeks, date + limit.weeks, date + 1.weeks]
      when time_types["month"]
        [date - 100.months, date + limit.months, date + 1.months]
      when time_types["hour"]
        [date - 100.hours, date + limit.hours, date + 1.hours]
      when time_types["m15"]
        [date - (100*15).minutes, date + (limit*15).minutes, date + 15.minutes]
      end
    end
  end
end
