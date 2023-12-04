class HourAnalytic < ApplicationRecord
  # 7h-14h: buổi sáng, 15-19h: buổi chiều, 20h-23h: buổi tối, 0h-6h 
  # https://github.com/bachpx195/bach-s_trading_room/wiki/C%C3%A1c-phi%C3%AAn-giao-d%E1%BB%8Bch-trong-ng%C3%A0y
  belongs_to :candlestick

  enum candlestick_type: {increase: 0, decrease: 1}

  # - 0.3 <= sideway <= 0.3
  # 0.3 < increase_type <= 1
  # -1 <= decrease_type < -0.3
  # increase_strong > 1
  # decrease_strong < -1
  enum range_type: {increase_strong: 0, increase_type: 1, sideway: 2, decrease_type: 3, decrease_strong: 4}

  def is_highest_hour_return_inday?
    hour_return_inday_max = HourAnalytic.where(date_with_binane: self.date_with_binane).pluck(:return_hl).max

    self.return_hl == hour_return_inday_max
  end

  def self.get_reverse_increase_hour day_with_binace
    reverse_increase_hour = nil
    highest = 0
    HourAnalytic.joins(:candlestick)
      .select('hour_analytics.hour, candlesticks.high')
      .where(date_with_binane: day_with_binace)
      .each do |ha|
        if ha.high > highest
          reverse_increase_hour = ha.hour
          highest = ha.high
        end
      end

    reverse_increase_hour
  end

  def self.get_reverse_decrease_hour day_with_binace
    reverse_decrease_hour = nil
    lowest = 10000000
    HourAnalytic.joins(:candlestick)
      .select('hour_analytics.hour, candlesticks.low')
      .where(date_with_binane: day_with_binace)
      .each do |ha|
        if ha.low < lowest
          reverse_decrease_hour = ha.hour
          lowest = ha.low
        end
      end

    reverse_decrease_hour
  end

  def get_previous_day_type
    yesterday = self.date.yesterday
    hour_yesterday = HourAnalytic.where(date: yesterday, hour: self.hour)
    return nil unless hour_yesterday.present?
    hour_yesterday.first.candlestick_type
  end
end
